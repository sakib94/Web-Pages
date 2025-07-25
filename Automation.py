import json
import time
import pyautogui
from pywinauto import Application, Desktop
import logging
import os
import subprocess

# Directories
script_dir = os.path.dirname(os.path.abspath(__file__))
image_dir = os.path.join(script_dir, "Images")
log_dir = os.path.join(script_dir, "logs")

# Ensure log directory exists
os.makedirs(log_dir, exist_ok=True)

# Clear previous log contents
log_file = os.path.join(log_dir, 'automation.log')
with open(log_file, 'w'):
    pass  # This will truncate (clear) the file

# Setup logging
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Read input.json
try:
    with open(os.path.join(script_dir, 'input.json'), 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    logging.error("input.json not found")
    print("Error: input.json not found")
    exit(1)

Password = data.get('password', '')
CIPackage = data.get('ciPackage', '')
CCPackage = data.get('ccPackage', '')
DeploymentType = data.get('deploymentType', '')

# Configure pyautogui
pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0.5

# Check OpenCV availability
try:
    import cv2
    OPENCV_INSTALLED = True
except ImportError:
    OPENCV_INSTALLED = False
    logging.warning("OpenCV is not installed. Confidence argument will be ignored in image recognition.")

def find_and_click_image(image_name, confidence=0.8, retries=3, delay=2):
    image_path = os.path.join(image_dir, image_name)

    if not os.path.exists(image_path):
        logging.warning(f"Image not found: {image_path}")
        return False

    for attempt in range(retries):
        try:
            if OPENCV_INSTALLED:
                location = pyautogui.locateCenterOnScreen(image_path, confidence=confidence)
            else:
                location = pyautogui.locateCenterOnScreen(image_path)

            if location:
                pyautogui.click(location)
                logging.info(f"Clicked on image: {image_name}")
                return True
        except Exception as e:
            logging.warning(f"Error locating {image_name}: {str(e)}")

        time.sleep(delay)

    logging.warning(f"Failed to click image after {retries} attempts: {image_name}")
    return False

def launch_setup():    
    exe_path = os.path.join(script_dir, 'SRS Deployer V2', 'setup.exe')

    if not os.path.exists(exe_path):
        logging.error(f"Setup.exe not found at: {exe_path}")
        print(f"Executable not found at {exe_path}")
        return False

    try:
        subprocess.Popen(f'start "" "{exe_path}"', shell=True)
        logging.info("Launched setup.exe from setup folder in foreground")
        return True
    except Exception as e:
        logging.error(f"Failed to launch setup.exe: {e}")
        return False

####### CoreIssue Deployment ########
def coreIssue():
    if not launch_setup():
        return

    time.sleep(5)

    # Bring app to focus
    try:
        app = Application(backend="uia").connect(title_re="SRS Report Deployer")
        main_dlg = app.window(title_re="SRS Report Deployer")
        main_dlg.set_focus()
    except Exception as e:
        logging.error(f"Could not connect to SRS Report Deployer window: {e}")
        return

    if not find_and_click_image('url_textbox.png'): return
    pyautogui.write("http://sahmad/reportserver/")
    pyautogui.press("enter")
    time.sleep(5)

    if not find_and_click_image('connect_button.png'): return
    time.sleep(20)

    if not find_and_click_image('report_folder_box.png'): return
    pyautogui.write("/Sakib_CI_AMEX")
    time.sleep(2)

    if not find_and_click_image('package_path_box.png'): return
    pyautogui.write(CIPackage + "\\Online")
    time.sleep(2)

    if not find_and_click_image('deploy_folder_button.png'): return
    time.sleep(2)

    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(2)

    if not find_and_click_image('define_data_source_button.png'): return
    time.sleep(2)

    data_source_dlg = Desktop(backend="uia").window(title_re="Report Data Source")

    if not find_and_click_image('server_box.png'): return
    pyautogui.write("BPLQADB01")
    time.sleep(2)

    if not find_and_click_image('database_box.png'): return
    pyautogui.write("Sakib_CI")
    time.sleep(2)

    if not find_and_click_image('secure_credentials_radio.png'): return
    time.sleep(2)

    if not find_and_click_image('username_box.png'): return
    pyautogui.write("Sakib.Ahmad")
    time.sleep(2)

    if not find_and_click_image('password_box.png'): return
    pyautogui.write(Password)
    time.sleep(2)

    if not find_and_click_image('use_windows_checkbox.png'): return
    time.sleep(2)

    if not find_and_click_image('test_connection_button.png'): return
    time.sleep(2)

    for image in [
        'ok_button.png', 'ok_button.png',
        'save_connection_button.png', 'no_button.png', 'ok_button.png']:
        if not find_and_click_image(image): return
        time.sleep(2)

    data_source_dlg.minimize()

    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(120)
    if not find_and_click_image('ok_button.png'): return

    if not find_and_click_image('package_path_box_02.png'): return
    pyautogui.write(CIPackage + "\\RD")
    time.sleep(2)
    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(3)
    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(60)
    if not find_and_click_image('ok_button.png'): return

    if not find_and_click_image('package_path_box_02.png'): return
    pyautogui.write(CIPackage + "\\Common_Online_RD_Reports")
    time.sleep(2)
    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(3)
    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(90)

    # Check for deployment success message on screen
    success_image = os.path.join(image_dir, 'deployment_completed.png')

    if os.path.exists(success_image):
        try:
            if OPENCV_INSTALLED:
                success_location = pyautogui.locateOnScreen(success_image, confidence=0.85)
            else:
                success_location = pyautogui.locateOnScreen(success_image)

            if success_location:
                logging.info("Deployment Completed.png message detected on screen.")
                logging.info("CoreIssue Reports deployed successfully!")
        except Exception as e:
            logging.warning(f"Error checking for deployment success message: {e}")
    else:
        logging.warning("Success message image 'deployment_completed.png' not found in Images folder.")
    time.sleep(5)
    if not find_and_click_image('ok_button.png'): return
	
    try:
        main_dlg.close()
        data_source_dlg.close()
    except Exception as e:
        logging.warning(f"Could not close windows: {e}")
 #########################################################

####### CoreCollect Deployment ########
def coreCollect():
    if not launch_setup():
        return

    time.sleep(20)

    # Bring app to focus
    try:
        app = Application(backend="uia").connect(title_re="SRS Report Deployer")
        main_dlg = app.window(title_re="SRS Report Deployer")
        main_dlg.set_focus()
    except Exception as e:
        logging.error(f"Could not connect to SRS Report Deployer window: {e}")
        return

    if not find_and_click_image('url_textbox.png'): return
    pyautogui.write("http://sahmad/reportserver/")
    pyautogui.press("enter")
    time.sleep(5)

    if not find_and_click_image('connect_button.png'): return
    time.sleep(20)

    if not find_and_click_image('report_folder_box.png'): return
    pyautogui.write("/Sakib_CC_AMEX")
    time.sleep(2)

    if not find_and_click_image('package_path_box.png'): return
    pyautogui.write(CCPackage + "\\OnlineReports")
    time.sleep(2)

    if not find_and_click_image('deploy_folder_button.png'): return
    time.sleep(2)

    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(2)

    if not find_and_click_image('define_data_source_button.png'): return
    time.sleep(2)

    data_source_dlg = Desktop(backend="uia").window(title_re="Report Data Source")

    if not find_and_click_image('server_box.png'): return
    pyautogui.write("BPLQADB01")
    time.sleep(2)

    if not find_and_click_image('database_box.png'): return
    pyautogui.write("Sakib_CC")
    time.sleep(2)

    if not find_and_click_image('secure_credentials_radio.png'): return
    time.sleep(2)

    if not find_and_click_image('username_box.png'): return
    pyautogui.write("Sakib.Ahmad")
    time.sleep(2)

    if not find_and_click_image('password_box.png'): return
    pyautogui.write(Password)
    time.sleep(2)

    if not find_and_click_image('use_windows_checkbox.png'): return
    time.sleep(2)

    if not find_and_click_image('test_connection_button.png'): return
    time.sleep(2)

    for image in [
        'ok_button.png', 'ok_button.png',
        'save_connection_button.png', 'no_button.png', 'ok_button.png']:
        if not find_and_click_image(image): return
        time.sleep(2)

    data_source_dlg.minimize()

    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(30)
    if not find_and_click_image('ok_button.png'): return

    if not find_and_click_image('package_path_box_02.png'): return
    pyautogui.write(CCPackage + "\\RD_Reports")
    time.sleep(2)
    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(3)
    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(10)
    if not find_and_click_image('ok_button.png'): return

    if not find_and_click_image('package_path_box_02.png'): return
    pyautogui.write(CCPackage + "\\Common Online and RD Reports")
    time.sleep(2)
    if not find_and_click_image('LoadPackage_button.png'): return
    time.sleep(3)
    if not find_and_click_image('deploy_reports_button.png'): return
    time.sleep(30)

    # Check for deployment success message on screen
    success_image = os.path.join(image_dir, 'deployment_completed.png')

    if os.path.exists(success_image):
        try:
            if OPENCV_INSTALLED:
                success_location = pyautogui.locateOnScreen(success_image, confidence=0.85)
            else:
                success_location = pyautogui.locateOnScreen(success_image)

            if success_location:
                logging.info("Deployment Completed.png message detected on screen.")
                logging.info("CoreCollect Reports deployed successfully!")
        except Exception as e:
            logging.warning(f"Error checking for deployment success message: {e}")
    else:
        logging.warning("Success message image 'deployment_completed.png' not found in Images folder.")
    time.sleep(5)
    if not find_and_click_image('ok_button.png'): return
    try:
        main_dlg.close()
        data_source_dlg.close()
    except Exception as e:
        logging.warning(f"Could not close windows: {e}")
 #########################################################
 
def main():
    logging.info(f"Deployment started with type: {DeploymentType}")
    if DeploymentType == "CI":
        time.sleep(5)
        coreIssue()
    elif DeploymentType == "CC":
        time.sleep(5)	
        coreCollect()
    elif DeploymentType == "BOTH":
        time.sleep(5)	
        coreIssue()
        coreCollect()
    else:
        print("Invalid deployment type")

if __name__ == '__main__':
    main()
