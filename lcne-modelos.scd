// Live code net ensamble
// Modelos de creaci—n de sonido + secuencia

// Interconexi—n a la red local
C—digo de History + C—digo de MandelHub

// Sonido + Secuencia
// Podemos usar estos modelos para dise–ar sonidos y secuenciarlos

Ndef + Ndef -> Pbind // basado en Patterns

Ndef + Tdef // basado en rutinas

SynthDef + Pdef // basado en Patterns

SynthDef + Tdef // basado en rutinas

// Entonces podemos trabajar mediante el dise–o de sonidos usando nuestros SynthDef o Ndefs
// Podemos secuanciarlos mediante Tdef (tareas) o Patterns (streams)
// Tan solo debemos ponernos de acuerdo en el tiempo, el \dur (Pbind) y el .wait (Tdef), ademas de la cuantizaci—n .quant_(4)

// Podemos explorar otros Proxies Pbindef, PatternProxy etc. (ver ayuda de JITLib: Patterns)

// A futuro para los visuales
// Podemos sustraer datos mediante MandelHub, para lo cual necesitamos revisar la parte de la ayuda de MandelHub:
// 02. Sharing data with MandelSpace
