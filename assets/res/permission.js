alert("Hello");
navigator.mediaDevices
  .getUserMedia({ audio: true, video: true })
  .then((stream) => {
    alert("STREAM");
    console.log("Got Media Stream: ", stream);
  })
  .catch((error) => {
    alert(error);
    console.error("Error : ", error);
  });
