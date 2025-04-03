import tkinter as tk
from tkinter import messagebox
import speech_recognition as sr
import pyperclip
import threading

recognizer = sr.Recognizer()
listening = False
stop_listening = False

def recognize_speech():
    global listening, stop_listening
    if listening:
        return
    
    stop_listening = False
    status_label.config(text="Listening...")
    root.update()
    
    def listen():
        global listening, stop_listening
        with sr.Microphone() as source:
            recognizer.adjust_for_ambient_noise(source)
            try:
                while not stop_listening:
                    audio = recognizer.listen(source, timeout=5)
                    text = recognizer.recognize_google(audio)
                    text_area.delete("1.0", tk.END)
                    text_area.insert(tk.END, text)
                    status_label.config(text="Done")
                    break
            except sr.UnknownValueError:
                messagebox.showerror("Error", "Could not understand the audio")
                status_label.config(text="Try Again")
            except sr.RequestError:
                messagebox.showerror("Error", "Could not request results from Google Speech Recognition service")
                status_label.config(text="Network Error")
            except Exception as e:
                messagebox.showerror("Error", str(e))
                status_label.config(text="Error")
            finally:
                listening = False
    
    threading.Thread(target=listen, daemon=True).start()

def stop_recognition():
    global stop_listening
    stop_listening = True
    status_label.config(text="Stopped Listening")

def copy_to_clipboard():
    text = text_area.get("1.0", tk.END).strip()
    if text:
        pyperclip.copy(text)
        messagebox.showinfo("Success", "Text copied to clipboard!")
    else:
        messagebox.showwarning("Warning", "No text to copy!")

def show_main_ui():
    root.deiconify()
    floating_button.withdraw()

def hide_main_ui():
    root.withdraw()
    floating_button.deiconify()

def move(event):
    floating_button.geometry(f"+{event.x_root}+{event.y_root}")

def exit_app():
    root.destroy()
    floating_button.destroy()

# Floating Button Setup
floating_button = tk.Tk()
floating_button.overrideredirect(True)
floating_button.geometry("50x50+100+100")
floating_button.attributes("-topmost", True)

btn = tk.Button(floating_button, text="🎤", font=("Arial", 16), command=show_main_ui, bg="#333333", fg="white", bd=0, relief=tk.FLAT)
btn.pack(expand=True, fill=tk.BOTH)
btn.bind("<B1-Motion>", move)

exit_floating = tk.Button(floating_button, text="✖", font=("Arial", 10), command=exit_app, bg="red", fg="white", bd=0)
exit_floating.pack(side=tk.BOTTOM, fill=tk.X)

# Main Speech to Text UI
root = tk.Toplevel()
root.title("Speech to Text")
root.geometry("400x300")
root.configure(bg="#000000")
root.withdraw()  # Start hidden

root.protocol("WM_DELETE_WINDOW", hide_main_ui)

title_label = tk.Label(root, text="Speech to Text Converter", font=("Arial", 14, "bold"), bg="#000000", fg="white")
title_label.pack(pady=10)

text_area = tk.Text(root, height=5, width=50, bg="#333333", fg="white")
text_area.pack(pady=10)

status_label = tk.Label(root, text="Press 'Start' to begin", font=("Arial", 10), bg="#000000", fg="white")
status_label.pack()

start_button = tk.Button(root, text="Start Listening", command=recognize_speech, bg="#4CAF50", fg="white", font=("Arial", 12))
start_button.pack(pady=5)

stop_button = tk.Button(root, text="Stop Listening", command=stop_recognition, bg="#FF5733", fg="white", font=("Arial", 12))
stop_button.pack(pady=5)

copy_button = tk.Button(root, text="Copy to Clipboard", command=copy_to_clipboard, bg="#008CBA", fg="white", font=("Arial", 12))
copy_button.pack(pady=5)

exit_button = tk.Button(root, text="Exit App", command=exit_app, bg="#888888", fg="white", font=("Arial", 12))
exit_button.pack(pady=5)

floating_button.mainloop()
