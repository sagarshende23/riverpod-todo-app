import tkinter as tk
from tkinter import ttk
import json
import os

class TodoApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Todo App")
        self.root.geometry("400x500")
        
        # Load todos
        self.todos = self.load_todos()
        
        # Create GUI elements
        self.create_widgets()
        
    def create_widgets(self):
        # Input frame
        input_frame = ttk.Frame(self.root, padding="10")
        input_frame.pack(fill=tk.X)
        
        self.todo_entry = ttk.Entry(input_frame)
        self.todo_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        add_button = ttk.Button(input_frame, text="Add", command=self.add_todo)
        add_button.pack(side=tk.RIGHT)
        
        # List frame
        list_frame = ttk.Frame(self.root, padding="10")
        list_frame.pack(fill=tk.BOTH, expand=True)
        
        self.todo_listbox = tk.Listbox(list_frame)
        self.todo_listbox.pack(fill=tk.BOTH, expand=True)
        
        delete_button = ttk.Button(list_frame, text="Delete Selected", command=self.delete_todo)
        delete_button.pack(pady=10)
        
        self.update_list()
        
    def add_todo(self):
        todo = self.todo_entry.get().strip()
        if todo:
            self.todos.append(todo)
            self.save_todos()
            self.todo_entry.delete(0, tk.END)
            self.update_list()
            
    def delete_todo(self):
        selection = self.todo_listbox.curselection()
        if selection:
            index = selection[0]
            del self.todos[index]
            self.save_todos()
            self.update_list()
            
    def update_list(self):
        self.todo_listbox.delete(0, tk.END)
        for todo in self.todos:
            self.todo_listbox.insert(tk.END, todo)
            
    def load_todos(self):
        try:
            with open('todos.json', 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return []
            
    def save_todos(self):
        with open('todos.json', 'w') as f:
            json.dump(self.todos, f)

if __name__ == '__main__':
    root = tk.Tk()
    app = TodoApp(root)
    root.mainloop()
