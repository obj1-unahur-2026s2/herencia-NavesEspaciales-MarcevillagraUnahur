class NaveEspacial {
  var velocidad = 0
  var direccion = 0
  var combustible = 0

  method velocidad() = velocidad
  method direccion() = direccion
  method combustible() = combustible

  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }

  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }

  method irHaciaElSol() {
    direccion = 10
  }

  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }

  method cargarCombustible(litros) {
    combustible += litros
  }

  method descargarCombustible(litros) {
    combustible = (combustible - litros).max(0)
  }

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.prepararViajeEspecial()
  }

  method prepararViajeEspecial()

  method estaTranquila() = combustible >= 4000 and velocidad <= 12000

  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  method escapar()
  method avisar()

  method tienePocaActividad() = true

  method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial {
  var colorDeBaliza = "verde"
  var cambiosDeColor = 0

  method colorDeBaliza() = colorDeBaliza
  method cambiosDeColor() = cambiosDeColor

  method cambiarColorDeBaliza(colorNuevo) {
    colorDeBaliza = colorNuevo
    cambiosDeColor += 1
  }

  override method prepararViajeEspecial() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila() = super() and colorDeBaliza != "rojo"

  override method escapar() {
    self.irHaciaElSol()
  }

  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad() = cambiosDeColor == 0
}

class NavePasajeros inherits NaveEspacial {
  const pasajeros
  var racionesComida = 0
  var racionesBebida = 0
  var racionesComidaServidas = 0

  method pasajeros() = pasajeros
  method racionesComida() = racionesComida
  method racionesBebida() = racionesBebida
  method racionesComidaServidas() = racionesComidaServidas

  method cargarComida(cantidad) {
    racionesComida += cantidad
  }

  method descargarComida(cantidad) {
    racionesComida = (racionesComida - cantidad).max(0)
  }

  method cargarBebida(cantidad) {
    racionesBebida += cantidad
  }

  method descargarBebida(cantidad) {
    racionesBebida = (racionesBebida - cantidad).max(0)
  }

  override method prepararViajeEspecial() {
    self.cargarComida(4 * pasajeros)
    self.cargarBebida(6 * pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar() {
    self.acelerar(velocidad)
  }

  override method avisar() {
    racionesComida = (racionesComida - pasajeros).max(0)
    racionesBebida = (racionesBebida - pasajeros * 2).max(0)
    racionesComidaServidas += pasajeros
  }

  override method tienePocaActividad() = racionesComidaServidas < 50
}

class NaveHospital inherits NavePasajeros {
  var quirofanosPreparados = false

  method quirofanosPreparados() = quirofanosPreparados

  method prepararQuirofanos() {
    quirofanosPreparados = true
  }

  override method estaTranquila() = super() and not quirofanosPreparados

  override method recibirAmenaza() {
    super()
    quirofanosPreparados = true
  }
}

class NaveCombate inherits NaveEspacial {
  var visible = true
  var misilesDesplegados = false
  const mensajes = []

  method visible() = visible
  method misilesDesplegados() = misilesDesplegados
  method mensajesEmitidos() = mensajes

  method ponerseVisible() {
    visible = true
  }

  method ponerseInvisible() {
    visible = false
  }

  method estaInvisible() = not visible

  method desplegarMisiles() {
    misilesDesplegados = true
  }

  method replegarMisiles() {
    misilesDesplegados = false
  }

  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }

  method primerMensajeEmitido() = mensajes.first()

  method ultimoMensajeEmitido() = mensajes.last()

  method esEscueta() = mensajes.all({ m => m.size() <= 30 })

  method emitioMensaje(mensaje) = mensajes.contains(mensaje)

  override method prepararViajeEspecial() {
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = super() and not misilesDesplegados

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }

  override method tienePocaActividad() = self.esEscueta()
}

class NaveCombateSigilosa inherits NaveCombate {
  override method estaTranquila() = super() and visible

  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
