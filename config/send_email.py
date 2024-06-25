import smtplib
import os
import glob
import csv
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

def find_images(directory, extension="png"):
    """Encuentra todas las imágenes con la extensión dada en el directorio y sus subdirectorios."""
    pattern = os.path.join(directory, f"**/*.{extension}")
    return glob.glob(pattern, recursive=True)

def send_email_with_attachments(subject, body, to_emails, from_email, smtp_server, smtp_port, login, password, image_paths):
    """Envía un correo electrónico con las imágenes adjuntas a múltiples destinatarios."""
    # Crear un objeto MIMEMultipart
    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = ', '.join(to_emails)  # Agregar todos los destinatarios en una sola cabecera
    msg['Subject'] = subject

    # Adjuntar el cuerpo del correo
    msg.attach(MIMEText(body, 'plain'))

    # Leer y adjuntar cada imagen
    for image_path in image_paths:
        with open(image_path, 'rb') as img_file:
            img = MIMEImage(img_file.read())
            img.add_header('Content-Disposition', f'attachment; filename={os.path.basename(image_path)}')
            msg.attach(img)

    # Establecer la conexión con el servidor SMTP
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.starttls()  # Usar TLS
    server.login(login, password)
    
    # Enviar el correo a todos los destinatarios
    server.sendmail(from_email, to_emails, msg.as_string())
    
    server.quit()

def read_config_from_csv(csv_file):
    """Lee la configuración desde un archivo CSV."""
    with open(csv_file, mode='r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        config = next(reader)
    return config

def main():
    """Función principal para leer configuración, encontrar imágenes y enviar el correo."""
    # Ruta al archivo CSV
    csv_file = '/home/input/config_email.csv'

    # Leer la configuración desde el archivo CSV
    config = read_config_from_csv(csv_file)

    # Extraer los parámetros de configuración
    subject = config['subject']
    body = config['body']
    to_emails = config['to_email'].split(',')  # Convertir a lista de correos electrónicos
    from_email = config['from_email']
    smtp_server = config['smtp_server']
    smtp_port = int(config['smtp_port'])  # Asegurarse de que el puerto es un entero
    login = config['login']
    password = config['password']
    directory = config['directory']

    # Encontrar todas las imágenes .png en el directorio y subdirectorios
    image_paths = find_images(directory, "png")

    # Enviar el correo
    send_email_with_attachments(subject, body, to_emails, from_email, smtp_server, smtp_port, login, password, image_paths)

# Ejecutar la función principal
if __name__ == "__main__":
    main()
