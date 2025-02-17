


### LLM en local: Corriendo DeepSeek R1 y Open WebUI con Docker Compose

¡Claro! Vamos a desglosar todo esto de una manera sencilla y amena para que lo entiendas bien.

### ¿Qué es la Inteligencia Artificial (IA)?

La Inteligencia Artificial (IA) es como enseñarle a una computadora a pensar y actuar de manera similar a como lo haría un humano. Imagina que tienes un robot que puede aprender a jugar ajedrez, reconocer imágenes de gatos, o incluso ayudarte a escribir un ensayo. Eso es IA en acción. La IA se basa en algoritmos y modelos que permiten a las máquinas aprender de los datos y tomar decisiones basadas en ese aprendizaje.

### ¿Qué son los LLM (Large Language Models)?

Los LLM, o Modelos de Lenguaje de Gran Escala, son un tipo de IA especializada en entender y generar texto. Piensa en ellos como super-lectores y escritores que han leído una cantidad enorme de libros, artículos y páginas web. Gracias a eso, pueden ayudarte a redactar textos, responder preguntas, traducir idiomas, y mucho más. Ejemplos famosos de LLM son GPT-3, BERT, y el que mencionas, DeepSeek R1.

### ¿Qué es Docker y Docker Compose?

Docker es una herramienta que te permite crear, desplegar y ejecutar aplicaciones en contenedores. Un contenedor es como una caja que contiene todo lo que una aplicación necesita para funcionar: el código, las librerías, las dependencias, etc. Esto hace que sea muy fácil mover la aplicación de un lugar a otro sin preocuparte de que algo falle.

Docker Compose es una herramienta que te permite manejar múltiples contenedores a la vez. Imagina que tienes una aplicación que necesita una base de datos, un servidor web, y un servicio de IA. Con Docker Compose, puedes definir todos estos servicios en un archivo y levantarlos todos juntos con un solo comando.

### ¿Qué es Open WebUI?

Open WebUI es una interfaz gráfica que te permite interactuar con modelos de lenguaje como DeepSeek R1 de una manera más amigable. En lugar de tener que escribir comandos en una terminal, puedes usar una página web para hacer preguntas y obtener respuestas del modelo.

### ¿Qué es Ollama?

Ollama es un servicio que te permite ejecutar modelos de lenguaje en tu propia máquina. Es como tener tu propio asistente de IA personal que puedes usar sin necesidad de conectarte a internet.

### ¿Cómo funciona todo esto juntos?

1. **Docker Compose**: En el archivo `docker-compose.yml` defines dos servicios:
   - **webui**: Este es el servicio de Open WebUI, que te da una interfaz gráfica para interactuar con el modelo de lenguaje.
   - **ollama**: Este es el servicio que ejecuta el modelo de lenguaje DeepSeek R1.

2. **Levantar los servicios**: Con el comando `docker compose up`, levantas ambos servicios. Open WebUI estará disponible en `http://localhost:3000`, y Ollama estará listo para ejecutar el modelo de lenguaje.

3. **Descargar el modelo**: Con el comando `docker exec -it ollama-ollama ollama pull deepseek-r1`, descargas el modelo DeepSeek R1 en el contenedor de Ollama.

4. **Interactuar con el modelo**: Puedes hacerlo de dos maneras:
   - **Interfaz gráfica**: Accede a `http://localhost:3000` y usa Open WebUI para interactuar con el modelo.
   - **Línea de comandos**: Entra al contenedor de Ollama con `docker exec -it ollama-ollama` y ejecuta `ollama run deepseek-r1` para interactuar directamente con el modelo desde la terminal.



### FUENTE: https://a-chacon.com/docker/2025/01/27/run-deepseek-locally.html
> vi docker-compose.yml
```sh
services:
  webui:
    image: ghcr.io/open-webui/open-webui:main
    ports:
      - 3000:8080/tcp
    volumes:
      - open-webui:/app/backend/data
    extra_hosts:
      - "host.docker.internal:host-gateway"
    depends_on:
      - ollama

  ollama:
    image: ollama/ollama
    expose:
      - 11434/tcp
    ports:
      - 11434:11434/tcp
    healthcheck:
      test: ollama --version || exit 1
    volumes:
      - ollama:/root/.ollama

volumes:
  ollama:
  open-webui:
```

> docker compose up

Falta inidcarle el LLMM existe una forma gráfica de hacerlo desde Open WebUI y otra por línea de comandos directamente en el contenedor de Ollama
> docker exec -it <nombre_del_contenedor_ollama> ollama pull deepseek-r1

**Acceder a http://localhost:3000**

[Aquí](https://ollama.com/library) puedes ver todos los modelos disponibles.
Además, puedes interactuar con el modelo a nivel de línea de comandos. 

Si entras al contenedor de Ollama, puedes ejecutar 

> ollama run deepseek-r1 

ó

> docker exec -it <nombre_del_contenedor_ollama> ollama run deepseek-r1


e interactuar sin la necesidad de una UI.