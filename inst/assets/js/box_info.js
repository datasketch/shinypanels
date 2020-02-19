

const collapsibles = Array.prototype.map.call(
  document.getElementsByClassName("box-collapsible-trigger"),
  function (el) { return el }
);


collapsibles.forEach(function (collapsible) {
  console.log("hola");
  console.log(collapsible);
  const content = collapsible.nextElementSibling;
  if (content.classList.contains('active')) {
    content.style.maxHeight = content.scrollHeight + "px";
  }

  collapsible.addEventListener('click', function () {
    this.classList.toggle('active');
    content.classList.toggle('active');
    if (content.style.maxHeight) {
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
});

