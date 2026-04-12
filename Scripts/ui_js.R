# Este archivo imprime el codigo JavaScript que:
# 1. Lee las secciones del documento.
# 2. Crea automaticamente los botones de la barra.
# 3. Muestra solo la seccion seleccionada.
# 4. Resalta el boton activo.
cat('
<script>
document.addEventListener("DOMContentLoaded", function () {
  // Se toma el contenedor donde vivira la barra
  const barra = document.getElementById("barra-secciones");

  // Se detectan todas las secciones del documento
  const secciones = document.querySelectorAll(".panel-seccion");

  // Funcion principal: activa una seccion y desactiva las demas
  function activarSeccion(id) {
    // Oculta todas las secciones
    secciones.forEach(sec => sec.classList.remove("activo"));

    // Quita el estado activo de todos los botones
    const botones = barra.querySelectorAll("button");
    botones.forEach(btn => btn.classList.remove("activa"));

    // Busca la seccion y el boton que corresponden al id recibido
    const seccionActiva = document.getElementById(id);
    const botonActivo = barra.querySelector(`button[data-target="${id}"]`);

    // Activa visualmente la seccion y su boton
    if (seccionActiva) seccionActiva.classList.add("activo");
    if (botonActivo) botonActivo.classList.add("activa");

    // Hace scroll suave hacia el contenido abierto
    if (seccionActiva) {
      seccionActiva.scrollIntoView({
        behavior: "smooth",
        block: "start"
      });
    }
  }

  // Recorre cada panel y crea un boton en la barra usando data-title
  secciones.forEach((sec, index) => {
    const id = sec.id;
    const titulo = sec.dataset.title;

    // Si falta el id o el titulo, la seccion no se agrega a la barra
    if (!id || !titulo) return;

    const boton = document.createElement("button");
    boton.textContent = titulo;
    boton.setAttribute("data-target", id);

    // Al hacer clic, se activa la seccion correspondiente
    boton.addEventListener("click", function () {
      activarSeccion(id);
    });

    barra.appendChild(boton);

    // La primera seccion se deja visible por defecto
    if (index === 0) {
      sec.classList.add("activo");
      boton.classList.add("activa");
    }
  });
});
</script>
', sep = "")