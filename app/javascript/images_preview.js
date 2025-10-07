document.addEventListener('turbo:load', () => {
  window.previewImage = (input, containerID) => {
    const files = input.files;
    const container = document.getElementById(containerID);
    container.innerHTML = '';
    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = () => {
        const img = document.createElement('img');
        img.src = reader.result;
        img.classList.add('img-thumbnail', 'w-32', 'h-32', 'object-cover');
        container.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  };
});
