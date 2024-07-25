import fetch from "node-fetch";

let user = {
  session_key: "-2511699999075787517"
}

const response = await fetch('http://127.0.0.1:3000/logout', {method: 'POST', body: JSON.stringify(user)});
const body = await response.json();

console.log(body);