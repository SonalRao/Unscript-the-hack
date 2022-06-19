const express =  require("express");
const app = express();
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const cors = require("cors")
const UserRouter = require("./router/userRoute")
const BookingROuter = require("./router/bookingRoute");
const AdminRoute = require("./router/AdminRoute");
const checkBookings =  require("./checkBookings");
const schedule = require("node-schedule");
require("dotenv").config();

const PORT = process.env.PORT || 3000;



// app.set('view engine', 'ejs');
app.use(cors())
app.use(bodyParser.urlencoded({extended:true}))
app.use(bodyParser.json())
// app.use(express.json())

app.use("/", UserRouter);
app.use("/", BookingROuter);
app.use("/",AdminRoute)

mongoose.connect(
  process.env.DB_URL,
  {
    useNewUrlParser: true,
    useCreateIndex: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
  },
  (err) => {
    if(err) console.log(`Error : ${err}`)
    else  console.log("Connected to MongoDB");
  }
)
app.listen(PORT,()=>{
    console.log(`Server started on port ${PORT}`);
})

schedule.scheduleJob("* * * *",()=>{
    checkBookings();
})