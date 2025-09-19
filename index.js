require('dotenv').config();
const app = require('./src/app.js');
// const db = require('./src/config/database.js');

app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});