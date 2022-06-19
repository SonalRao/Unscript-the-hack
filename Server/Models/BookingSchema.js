const mongoose = require("mongoose");
const { Schema } = mongoose;

const bookingSchema = new mongoose.Schema({
    userId:{
        type:Schema.Types.ObjectId,
        requiured:true,
    },
    parkingId:{
        type:Schema.Types.ObjectId,
    },
    PaymentAmount:{
        type:Number,
        required:true
    },
    Duration: {
        type:Number,
        required:true
    },
    Time:Schema.Types.Date,
    // OutTime:Schema.Types.Date,
    QrCode:{
        type:String,
    },
    PaymentConfirmation:{
        type:Boolean,
        default:false
    },
    Completed:{
        type:Boolean,
        default:false
    },
    PlaceName:{
        type: String,
        
    },
    NumberPlate :{
        type: String,
    }
})
const Booking = new mongoose.model("Booking",bookingSchema,"Booking");
module.exports = Booking;