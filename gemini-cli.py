import google.generativeai as genai
import sys

# Configure API with your key
genai.configure(api_key="AIzaSyCtOijdY_QdJiT_Epp1IqsCzsh8poW0r5w")
model = genai.GenerativeModel('gemini-1.5-flash')

def chat():
    print("=" * 60)
    print("Gemini CLI - Type 'exit' to quit, 'clear' to reset chat")
    print("=" * 60)
    
    chat_session = model.start_chat(history=[])
    
    while True
        try:
            user_input = input("\n> ")
            
            if user_input.lower() == 'exit':
                print("Goodbye!")
                break
            elif user_input.lower() == 'clear':
                chat_session = model.start_chat(history=[])
                print("Chat cleared!")
                continue
            
            response = chat_session.send_message(user_input)
            print(f"\n{response.text}\n")
            
        except KeyboardInterrupt:
            print("\n\nGoodbye!")
            break
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    chat()