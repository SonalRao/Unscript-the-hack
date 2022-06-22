const Booking = require("./Models/BookingSchema") 
const parking = require("./Models/parkingSchema")
const ObjectId = require("mongoose").Types.ObjectId;

const checkBookings = async () =>{
    const bookings = await Booking.find();
    const currenTime = new Date();
    bookings.map((booking)=>{
        const time = new Date(booking.Time)
        const endTime = time.setMinutes(time.getMinutes() + bookings.Duration * 60);
        if(endTime > currenTime){
            console.log("Booking completed!!")
            Booking.findOneAndUpdate({_id: new ObjectId(booking._id)},{Completed:true},{new:true})
            const Amount = booking.PaymentAmount; 
            parking.findOneAndUpdate({_id: new ObjectId(booking.parkingId)},{$inc:{occupied:-1},$inc:{Revenue:Amount}})
        }
    })
}

module.exports = checkBookings;