const mongoose =  require("mongoose");


const parkingSchema = new mongoose.Schema({
  phoneNumber: {
    type: String,
  },
  email:{
      type:String
  },
  password: {
    type: String,
  },
  placeName: {
    type: String,
    required: true,
  },
  Address: {
    type: String,
  },
  long:{
    type:String
  },
  lat:{
    type:String
  },
  Columns: {
    type: Number,
  },
  Row: {
    type: Number,
  },
  TotalSpace: {
    type: Number,
  },
  Revenue:{
    type:Number,
    default: 0
  },
  Type: {
    type: String,
    enum: ["Mall", "Stadium", "Others"],
  },
  Rate: { type: Number },
  image: { type: String },
  bookings: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Booking",
    },
  ],
  occupied: {
    type: Number,
    default: 0
  },
});



module.exports = new mongoose.model("parking",parkingSchema,"parking");