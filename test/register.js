import fetch from "node-fetch";

let user = {
  username:  "hello322",
  password:  "1234",
  confirm_password: "1234"
}

const response = await fetch('http://127.0.0.1:3000/register', {method: 'POST', body: JSON.stringify(user)});
const body = await response.json();

console.log(body);