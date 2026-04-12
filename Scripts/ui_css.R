# Este archivo imprime los estilos CSS del reporte.
# Su funcion es controlar la apariencia de la cabecera, la barra horizontal
# y los paneles de contenido que se muestran al hacer clic.

cat('
<style>
/* Estilo general del documento */
body {
  font-family: Arial, sans-serif;
}

/* Caja superior con el titulo y el enunciado */
.cabecera-documento {
  background: #f8fbff;
  border: 1px solid #d9e2ec;
  border-radius: 14px;
  padding: 24px;
  margin-bottom: 20px;
}

/* Titulo principal */
.cabecera-documento h1 {
  margin: 0 0 14px 0;
  font-size: 30px;
  color: #1f2d3d;
}

/* Parrafos del enunciado */
.cabecera-documento p {
  margin: 0 0 12px 0;
  font-size: 16px;
  line-height: 1.7;
  color: #425466;
}

/* Contenedor de la barra horizontal.
   sticky hace que quede visible al desplazarse por la pagina. */
.contenedor-barra {
  position: sticky;
  top: 0;
  z-index: 1000;
  background: #ffffff;
  padding: 12px 0 14px 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  margin-bottom: 24px;
}

/* Barra flexible y desplazable horizontalmente */
#barra-secciones {
  display: flex;
  gap: 10px;
  overflow-x: auto;
  white-space: nowrap;
  padding: 0 16px;
  scroll-behavior: smooth;
}

/* Botones de navegacion */
#barra-secciones button {
  border: none;
  background: #eef2f7;
  color: #2c3e50;
  padding: 10px 16px;
  border-radius: 999px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
  flex: 0 0 auto;
}

/* Cambio visual al pasar el mouse */
#barra-secciones button:hover {
  background: #dceaf7;
  color: #0b5ea8;
}

/* Estado visual del boton activo */
#barra-secciones button.activa {
  background: #0b5ea8;
  color: white;
}

/* Cada panel de contenido empieza oculto */
.panel-seccion {
  display: none;
  border: 1px solid #d9e2ec;
  border-radius: 12px;
  background: #fcfdff;
  margin: 18px 0;
}

/* Solo la seccion activa se muestra */
.panel-seccion.activo {
  display: block;
}

/* Espaciado interno del contenido de cada seccion */
.contenido-seccion {
  padding: 20px;
}
</style>
', sep = "")