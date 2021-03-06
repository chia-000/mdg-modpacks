$nombreModPack = 'MDG Server 1.18.1'
$rutaCarpetaActual = [System.Environment]::CurrentDirectory
$rutaMinecraft = $env:APPDATA + '/.minecraft'
$rutaVersiones = $rutaMinecraft + '/versions'
$rutaModPack = $rutaVersiones + '/' + $nombreModPack
$rutaModPackMODS = $rutaModPack + '/mods'

#Se reemplazan los espacios en el nombre del modpack para hacerlo url-friendly
$nombreModPackURL = $nombreModPack.Replace(' ', '%20')
$urlModPack = 'https://raw.githubusercontent.com/chia-000/mdg-modpacks/main/' + $nombreModPackURL

$mensaje = 'El mod pack <<' + $nombreModPack + '>> ha sido instalado exitosamente!'
$mensaje2 = 'Disfruta los mods!'

#Se crea la carpeta 'versions' si no existe
if (-Not (Test-Path $rutaVersiones)) {
	mkdir $rutaVersiones
}

#Se crea la carpeta del mod pack si no existe
if (-Not (Test-Path $rutaModPack)) {
	mkdir $rutaModPack
}

#se crea la carpeta mods por si no existe
if (-Not (Test-Path $rutaModPackMODS)) {
	mkdir $rutaModPackMODS
}

$nombreArchivoBackUp = '___backup.zip'
#Se descargan los archivos de backup del mod pack
$urlBackUp = $urlModPack + '/backup.zip'
#Se descarga el archivo backup del mod pack
echo '[ESTADO]: Descargando backup del mod pack'
curl $urlBackUp -OutFile $nombreArchivoBackUp
clear

$rutaBackUpZip = $rutaCarpetaActual + '/' + $nombreArchivoBackUp

#Se verifica si se pudo descargar el archivo zip de backup del mod pack
if (Test-Path $rutaBackUpZip) {
	echo '[ESTADO]: Restaurando backup del mod pack'
	Expand-Archive $rutaBackUpZip $rutaModPack -Force
	clear
}
else {
	$mensaje = '[ERROR]: Hubo un error al intentar descargar los archivos de backup del mod pack, posiblemente un error de conexion.'
	$mensaje2 = 'Puedes intentar correr el script de nuevo.'
}

$nombreModsZip = '___mods.zip'
$urlMods = $urlModPack + '/mods.zip'
#Se descargan los mods del mod pack
echo '[ESTADO]: Descargando los mods del mod pack'
curl $urlMods -OutFile $nombreModsZip
clear

$rutaModsZip = $rutaCarpetaActual + '/' + $nombreModsZip

#Se verifica si se pudo descargar los mods del mod pack
if (Test-Path $rutaModsZip) {
	$modsViejos = $rutaModPackMODS + '/*'
	#Se elimina el contenido de la carpeta mods de la carpeta del mod pack
	Remove-Item $modsViejos -Force

	echo '[ESTADO]: Instalando mods'
	#Descompresion del archivo zip en la carpeta de mods de minecraft
	Expand-Archive $rutaModsZip $rutaModPackMODS -Force
	clear
}
else {
	$mensaje = '[ERROR]: Hubo un error al intentar descargar los mods del mod pack, posiblemente un error de conexion.'
	$mensaje2 = 'Puedes intentar correr el script de nuevo.'
}

#Borrando archivos temporales
if (Test-Path $rutaBackUpZip) {
	Remove-Item -Path $rutaBackUpZip -Force
}

if (Test-Path $rutaModsZip) {
	Remove-Item -Path $rutaModsZip -Force
}

echo $mensaje
echo $mensaje2
echo ''
echo ''

pause