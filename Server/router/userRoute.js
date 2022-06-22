const express = require("express");
const User = require("../Models/userSchema")
const users = require('../Models/userSchema')
const Booking = require("../Models/BookingSchema")
const parking = require("../Models/parkingSchema")
const router = express.Router();
const bcrypt  = require('bcryptjs')
const ObjectId = require("mongoose").Types.ObjectId;
const axios = require("axios");
const validator = require("email-validator")
require("dotenv").config();

router.get('/',(req,res) =>{
    console.log("Home Page")
    const str = "2021-09-21 19:00:00.000" 
    const date = new Date(str)
    date.setHours(date.getHours()+5);
    date.setMinutes(date.getMinutes()+30);
    console.log(date);
    return res.status(200).json({});
})

router.post('/signin',async (req,res) =>{
    try{
        const {email, password} = req.body
        const userLogin = await User.findOne({email: email});
        if (userLogin){
            const isMatch = await bcrypt.compare(password, userLogin.password);
            if (!isMatch){
                res.status(400).json({errorMessage: "Invalid Credentials"})
    
            }
            else{
                res.status(200).json(userLogin)
            }

        }else{
            res.status(400).json({errorMessage: "User not registered"})

        }
        
    }catch(error){
        console.log(error);
        return res.status(400).json({ errorMessage: "Internal server error" });
}
})


router.post("/addDetails",async(req,res)=>{
    try {
        const id = new ObjectId(req.query.id);
        // const {carName,phoneNumber,carNumber,image} = req.body;
        const update = req.body;
        const user = await users.findOneAndUpdate({ _id: id }, update, {
            new: true,
        });
        res.status(200).json(user);
} catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }

})

router.post('/register',async (req,res) =>{
    try{
    const email = req.body.email;
    const password = req.body.password;
    if(!validator.validate(email)){
        return res.status(400).json({errorMessage:"Invalid email address"})
    }
    if(password.length<8){
        return res.status(400).json({errorMessage:"Password should be of minimun 8 characters"})
    }
    const user = await User.findOne({email: req.body.email});
    const hashedPassword = await bcrypt.hash(password,12);
    if(user==null){
        const userData = new User({
        fullname: req.body.fullname,
        email: req.body.email,
        password: hashedPassword
        });
        userData.save().then((err) => {
        /* if (err) {
            console.log(err);
            return res.status(400).json(err);
        } else {
            
        } */
        return res.status(200).json(userData);
        });
    }else{
        return res.status(400).json({errorMessage:"User already exists"})

}}catch(error){
        console.log(error);
        return res.status(400).json({errorMessage:error});
    }
})

router.get('/getprofile',async(req,res,next) =>{ 
    try{
        const id = req.query.id;
        const userDetails = await users.findById(new ObjectId(id));

        if(!userDetails)    return res.status(404).json({ errorMessage: "User not found!" });
        
        return res.status(200).json(userDetails);
        
    } catch(error){
        console.log(error);
        return res.status(400).json({errorMessage:"Internal server error"});
    }
})


router.patch('/profileEdit', async(req,res,next) =>{
    try{
        const id = req.query.id;
        const updates  = req.body;
        const options = {new: true};
       User.update({_id:id},{$set:updates})
       .exec()
       .then(result =>{
        res.status(200).json({
            message: 'Profile is edited',
            // request: {
            //     type: 'GET',
            //     url: 'http://localhost:3000/products/' + id
            // }
        });
       })


    } catch(error){
        console.log(error);
        return res.status(400).json({error});
    }
})

router.get("/bookingDetails",async (req,res)=>{
   try{

    const id = req.query.id;
    const bookingDetail = await Booking.findOne({ _id: new ObjectId(id) });
    return res.status(200).json(bookingDetail)

   }catch(error){

        console.log(error);
        return res.status(400).json({errorMessage:"Internal server error"})
   }
})

router.get("/recentBookings",async (req,res)=>{
    try {
        const userId = req.query.id;
        const user = await users.findOne({_id:new ObjectId(userId)});
        const recentBookings = await Promise.all(user.recentBookings.map((booking)=>{
            const bookings = Booking.findOne({ _id: new ObjectId(booking) })
            if(bookings){
                return bookings;
            }
            return;
        }))
        console.log(recentBookings);
        return res.status(200).json({"recentBookings":recentBookings})
    } catch (error) {
        console.log(error);
        return res.status(400).json({errorMessage:"Internal server error"})
    }
})


router.post("/allparkingdetails",async (req,res)=>{
    try {
        const {lat,long} = req.body;
        const parkingDetails = await parking.find();
        var data = [];
        for(let i=0;i<parkingDetails.length;i++){
            // console.log(parkingDetails[i]);
            const park = parkingDetails[i];
            const id = park._id;
            const parks = JSON.stringify(park);
            data[i] = park;
        }
        const details = await Promise.all(parkingDetails.map(async (park)=>{    
            const plong = park.long;
            const plat = park.lat;
            const token = process.env.MAPBOX_TOKEN;
            const data = await axios.get(
                `https://api.mapbox.com/directions/v5/mapbox/driving/${long}%2C${lat}%3B${plong}%2C${plat}?alternatives=false&geometries=geojson&steps=false&access_token=${token}`
            );
            park = { ...park._doc, duration: data.data.routes[0].duration,distance:data.data.routes[0].distance};
            //duration in seconds and distance in metres//
            return park;
        }))
        res.status(200).json({"allUsers":details});
    } catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }
})

// router.get("/route",async (req,res)=>{
//     try {
//         const parkings = await parking.find();
//         const list =  parkings.map((park)=>{
//             const data = axios.get(
//               "https://api.mapbox.com/directions/v5/mapbox/driving/75.37216136440054%2C19.877166731050636%3B75.31135965279282%2C19.859734183169437?alternatives=true&geometries=geojson&steps=true&access_token=pk.eyJ1IjoiYW1leTQ5NyIsImEiOiJja2htMDQzc20wYW9jMndxcXJ6OTllMGo1In0.FGiBqt1X-vZ6b4yZA76caQ"
//             );
//             return { _id: park._id, placeName: park.placeName };
//         })

//         res.status(200).json(list);
//     } catch (error) {
//         console.log(error);
//         res.status(400).json({ errorMessage: "Internal server error" });
//     }
// })

router.get("/parkingdetail",async (req,res)=>{
    try {
        const parkingId = req.query.parkingId;
        const parkingdetail =  await parking.findOne({_id:new ObjectId(parkingId)})
        return res.status(200).json(parkingdetail)
    } catch (error) {
        console.log(error);
        res.status(400).json({ errorMessage: "Internal server error" });
    }
})
module.exports = router;