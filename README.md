# UART_8_bit_transmitter_and_receiver

This project contains a Universal Asynchronous Receiver-Transmitter (UART) Verilog code along with its testbench. The design simulates a simple communication protocol where data is transmitted and received between a transmitter and a receiver.

1. Project Structure

The project structure is organized as follows:
- UART.v: Contains the Verilog code for the UART transmission and reception modules.
- UART_TB.v: The testbench to simulate the UART operation and validate its functionality.
- Trans.docx: Flowchart explaining the transmission process of the UART.
- Recv.docx: Flowchart explaining the receiving process of the UART.
- UART do.txt: Contains simulation commands, adding waveform signals for monitoring the inputs and outputs during simulation.
- Waveform


2. Features

Transmission:

- Sends a start bit, followed by 8 data bits, and ends with a stop bit.
- Checks if all data bits are sent.
- Sends data based on UART protocol.
  
Reception:

- Waits for the start bit to begin.
- Receives 8 data bits and then waits for a stop bit.
- Verifies if all bits are received correctly.

3. Simulation

To simulate the UART functionality:

- Load the UART_TB.v file in your Verilog simulation environment (e.g., ModelSim).
- Use the provided UART do.txt script for running the simulation.
