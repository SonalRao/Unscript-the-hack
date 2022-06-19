const mongoose = require("mongoose");
const {Schema} = mongoose;

const userSchema = new mongoose.Schema({
  fullname: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    trim: true,
  },
  carName: {
    type: String,
    trim: true,
  },
  carNumber: {
    type: String,
    trim: true,
  },
  phoneNumber: {
    type: Number,
  },
  image: {
    type: String,
    default:"assets/images/profile1.jpg",
  },
  recentBookings: [
    {
      type: Schema.Types.ObjectId,
      ref: "Booking",
    },
  ],
});

const User = new mongoose.model("User", userSchema,"users");
module.exports = User;
