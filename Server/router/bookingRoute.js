const express = require("express");
const router = express.Router();
const Booking = require("../Models/BookingSchema");
const users = require("../Models/userSchema");
const ObjectId = require("mongoose").Types.ObjectId;
const parking = require("../Models/parkingSchema");

router.post("/createBooking",async (req,res)=>{
    try {
        var {userId,
            parkingId,
            PaymentAmount,
            Duration,
            Time,
            PaymentConfirmation,
            PlaceName,
            NumberPlate,
            
        } = req.body;   
        console.log(Time);
        Time = new Date(Time);
        Time.setHours(Time.getHours() + 5)
        Time.setMinutes(Time.getMinutes() + 30)
        console.log(Time);
        //Time = new Date(Time);
        const bookingData = {
            userId,
            parkingId,
            PaymentAmount,
            Duration,
            Time,
            PaymentConfirmation,
            PlaceName,
            NumberPlate
        }
        console.log(bookingData);
        const booking = await Booking.create(bookingData);

        await users.findOneAndUpdate(
            {_id:new ObjectId(userId)},
            {
                $push:{recentBookings:booking._id},
                //currentBooking:booking._id
            }
        ).populate('recentBookings') 
        
        await parking.findOneAndUpdate(
            {_id:new ObjectId(parkingId)},
            {   
                $push:{bookings:booking._id},
                $inc:{occupied:1}
            }
        ).populate('bookings')

        return res.status(200).json({message:"Booking Successfull",BookingId:booking._id})
    } catch (error) {
        console.log({error})
        return res.status(400).json({errorMessage:"Internal server error"})
    }
})

router.post("/cancelBooking",async (req,res)=>{
    try {
        const bookingId = req.query.bookingId;
        const parkingId = req.query.parkingId;
        console.log(bookingId);
        console.log(parkingId);
        console.log("Before cancelling");

        const parkingDetail = await parking.findOneAndUpdate({_id:new ObjectId(parkingId)},{
            $inc:{occupied:-1}
        })
        await users.findOneAndUpdate({_id: new ObjectId(parkingDetail.userId)},{$pull: {recentBookings: new ObjectId(bookingId)}})
        await Booking.findOneAndDelete({_id:new ObjectId(bookingId)});
        console.log("After cancelling");
        res.status(200).json({"Success Message":"Cancel Successful"});
    } catch (error) {
        console.log(error);
        res.status(400).json({errorMessage:"Internal server error"})
    }
})


router.post("/renewBooking",async (req,res)=>{
    try {
        console.log("Sending request");
        const bookingId = req.query.bookingId;
        const addedDuration = req.body.duration;
        const newCost = req.body.newCost;
        const booking = await Booking.findOneAndUpdate({_id: new ObjectId(bookingId)},
        {$inc: {Duration:addedDuration},PaymentAmount : newCost})
        return res.status(200).json({"Renewal":"Booking Renewd Successfully"});
    } catch (error) {
        console.log(error);
        res.status(400).json({ errorMessage: "Internal server error" });
    }
})

router.get("/bookingDetails", async (req, res) => {
    try{
        const id = req.query.bookingId;
        const bookingDetail = await Booking.findById(new ObjectId(id));
        console.log(bookingDetail);
        return res.status(200).json(bookingDetail);
    }catch (error) {
        console.log(error);
        res.status(400).json({ errorMessage: "Internal server error" });
    }
})
module.exports = router;


