
# Este archivo imprime la estructura HTML fija que aparece antes del contenido
# del reporte: la cabecera del documento y el contenedor de la barra horizontal.

cat('
<div class="cabecera-documento">
  <!-- Titulo principal del documento -->
  <h1>Titulo del documento</h1>

  <!-- Enunciado o contexto general del problema -->
  <p>
  En una organización, se busca comprender y prever los factores que influyen en la rotación de empleados entre distintos cargos. 
  La empresa ha recopilado datos históricos sobre el empleo de sus trabajadores, incluyendo variables como la antigüedad en el cargo actual, 
  el nivel de satisfacción laboral, el salario actual, edad y otros factores relevantes. La gerencia planea desarrollar un modelo de regresión 
  logística que permita estimar la probabilidad de que un empleado cambie de cargo en el próximo período y determinar cuales factores indicen 
  en mayor proporción a estos cambios.

Con esta información, la empresa podrá tomar medidas proactivas para retener a su talento clave, identificar áreas de mejora en la gestión de recursos humanos y fomentar un ambiente laboral más estable y tranquilo. La predicción de la probabilidad de rotación de empleados ayudará a la empresa a tomar decisiones estratégicas informadas y a mantener un equipo de trabajo comprometido y satisfecho en sus roles actuales.

A continuación se describen los pasos que la gerencia ha propuesto para el análisis:
  </p>

  <!-- Objetivo del analisis -->
  <p>
    El proposito del analisis es desarrollar un modelo que permita identificar los factores mas
    asociados a los cambios de cargo y apoyar la toma de decisiones estrategicas en la organizacion.
  </p>
</div>

<!-- Contenedor independiente para la barra de navegacion -->
<div class="contenedor-barra">
  <!-- Aqui JavaScript insertara los botones de las secciones -->
  <div id="barra-secciones"></div>
</div>
', sep = "")