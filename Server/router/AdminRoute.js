const express = require("express");
const parking = require("../Models/parkingSchema");
const router = express.Router();
 const ObjectId = require("mongoose").Types.ObjectId;
 const bcrypt  = require('bcryptjs')
 const users = require('../Models/userSchema')
const Booking = require("../Models/BookingSchema")
const validator = require("email-validator")

router.post("/registerAdmin",async (req,res)=>{
    try {
        const email = req.body.email;
        const password = req.body.password;
        if(!validator.validate(email)){
            return res.status(400).json({errorMessage:"Invalid email address"})
        }
        if (password.length < 8) {
            return res
            .status(400)
            .json({
                errorMessage: "Password should be of minimun 8 characters",
            });
        }
        const admin = await parking.findOne({email:email});
        if(admin==null){
            const hashedPassword = await bcrypt.hash(req.body.password,12);
            const adminData = new parking({
                email:req.body.email,
                password:hashedPassword,
                placeName: req.body.name,
            })
            adminData.save().then((err)=>{
                return res.status(200).json();
            })
        }else{
            return res.status(400).json({errorMessage:"Admin already exists"})
        }
    } catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }
})

router.post("/adminSignin",async (req,res)=>{
    try {
        const {email,password} = req.body;
        const adminLogin = await parking.findOne({email:email});

        if(adminLogin){
            const isMatch = await bcrypt.compare(password,adminLogin.password);
            if(!isMatch){
                res.status(400).json({errorMessage:"Invalid credentials"})
            }else{
                res.status(200).json(adminLogin);
            }
        }else{
            res.status(400).json({errorMessage:"Admin not registered"})
        }
    } catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }
})


router.post("/addParkingDetails",async (req,res)=>{
    try {
        const parkingId = ObjectId(req.query.id);
        console.log(parkingId)
        const details = req.body;
        const admin = await parking.findOneAndUpdate({_id: parkingId},details,{new:true});
        console.log(admin)
        res.status(200).json(admin);
    } catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }
})

router.get("/parkingDetails",async(req,res)=>{
    try {
        const parkingId = req.query.id;
        const parkingDetails = await parking.findOne({_id:new ObjectId(parkingId)});

        res.status(200).json(parkingDetails);
    } catch (error) {
        console.log(error);
        return res.status(400).json({errorMessage:"Internal server error"})
    }
})

router.get("/currentBookings",async (req,res)=>{
    try {
        const parkingId = req.query.parkingId;
        const admin = await parking.findById(new ObjectId(parkingId))
        const currentBookings = await Promise.all(admin.bookings.map( (booking)=>{
            const bookings = Booking.findOne({ _id: new ObjectId(booking) })
            const completed = bookings.Completed;
            return bookings
        }))
        const bookingDetails =await Promise.all((currentBookings.filter((book)=>{
            if(book!=null && book.Completed==false){
                return book;
            }
        })))
        // bookingDetails.sort((a, b) => (a.Time > b.Time ? 1 : -1));
        res.status(200).json(bookingDetails);
    } catch (error) {
        console.log(error);
        return res.status(400).json({errorMessage:"Internal server error"})
    }
})
// router.post("/addParkingDetails",async(req,res)=>{
//     try {
//         const details = new parking(req.body);
//         details.save().then((err)=>{
//             if(err) {
//                 console.log(err);
//                 return res.status(400).json({errorMessage:"Internal server error"})
//             }
//         return res.status(200).json({message:"Parking space added!"})
//         })
        
//     } catch (error) {
//         console.log(error);
//         return res.status(400).json({errorMessage:"Internal server error"})
//     }
// })

module.exports = router