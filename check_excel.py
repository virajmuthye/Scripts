# This file will check a folder for a file with a prefix "MITO" and a suffix "xlsx".
# It will then filter for only mitochondrial genes and output an updated file.
# This script can be modified for any different file types and filtering steps.

import os
import time
import pandas as pd
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class FileHandler(FileSystemEventHandler):
    def __init__(self, folder_to_watch, pattern):
        self.folder_to_watch = folder_to_watch
        self.pattern = pattern

    def on_created(self, event):
        if not event.is_directory:
            file_path = event.src_path
            # Check if file is not already processed (i.e., doesn't have the '-updated' suffix)
            if os.path.basename(file_path).startswith(self.pattern) and file_path.endswith('.xlsx') and "-updated" not in file_path:
                print(f"Detected file: {file_path}")
                time.sleep(2)  # Ensure file write is complete
                self.process_file(file_path)

    def process_file(self, file_path):
        print(f"Processing file: {file_path}")
        try:
            # Read the Excel file
            df = pd.read_excel(file_path, engine='openpyxl')

            # Check and rename columns as necessary
            print("Column Names:", df.columns)
            if 'Unnamed: 0' in df.columns:
                df.rename(columns={'Unnamed: 0': 'Sample'}, inplace=True)

            # Perform quality control check 
            # This is where you can change  the column name and filtering step
            column_name = 'MitoCarta2.0_List'
            if column_name in df.columns:
                filtered_df = df[df['MitoCarta2.0_List'] == 1]
                print("Quality control check completed.")
            else:
                print(f"Column '{column_name}' not found in the file.")
                return

            # Save the updated file with a unique suffix
            base, ext = os.path.splitext(file_path)
            output_path = f"{base}-updated{ext}"
            filtered_df.to_excel(output_path, index=False)
            print(f"Updated file saved to: {output_path}")

        except PermissionError:
            print(f"Permission denied while processing file: {file_path}")
        except Exception as e:
            print(f"Error processing file {file_path}: {e}")

# Configure the folder to monitor and the file pattern
folder_to_watch = r"C:\Users\viraj\Downloads\TIGER_Monitor"
pattern = "MITO"

if __name__ == "__main__":
    if not os.path.exists(folder_to_watch):
        raise ValueError(f"The folder {folder_to_watch} does not exist.")

    # Set up the observer
    event_handler = FileHandler(folder_to_watch, pattern)
    observer = Observer()
    observer.schedule(event_handler, folder_to_watch, recursive=False)

    print(f"Monitoring folder: {folder_to_watch} for files starting with '{pattern}' and ending with '.xlsx'")

    try:
        observer.start()
        while True:
            time.sleep(1)  # Keep the script running
    except KeyboardInterrupt:
        print("Stopping the folder monitor.")
        observer.stop()

    observer.join()
