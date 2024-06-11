# UART Design in SystemVerilog

## Overview
This project involves the design and implementation of a Universal Asynchronous Receiver-Transmitter (UART) module in SystemVerilog. The UART module enables asynchronous serial communication, demonstrating sequential logic, state machines, and read/write control logic. The design works in full duplex mode, allowing simultaneous transmission and reception of data between two Basys3 boards, with data display on the on-board peripherals.

## Features
- **Full Duplex Communication**: Supports simultaneous transmission and reception of data.
- **Configurable UART Frame**:
  - 8 data bits
  - 1 parity bit (even or odd, based on configuration)
  - 1 stop bit
- **Baud Rate**: Configurable, default set to 115200.
- **FIFO Buffer**: 4-byte FIFO buffer for both transmitter (TXBUF) and receiver (RXBUF).
- **Display**: Data visualization on Basys3's 7-segment display and LEDs.
- **Automatic Transmission Mode**: Option to automatically send all bytes in TXBUF with a single button press.

## Usage
1. **Loading Data**:
   - Use the rightmost 8 switches (SW7-0) to input data.
   - Press the down button (BTND) to load the current byte into the transmitter buffer (TXBUF).
   - The loaded data is displayed on the rightmost 8 LEDs.

2. **Transmitting Data**:
   - Press the center button (BTNC) to initiate the transmission.
   - The receiver buffer (RXBUF) stores the received data and displays it on the leftmost 8 LEDs.

3. **Automatic Transmission Mode**:
   - Enable by setting the leftmost switch (SW15) to high.
   - Press BTNC to send all 4 bytes in TXBUF.

4. **Displaying Data on 7-Segment Display**:
   - The 7-segment display shows the contents of TXBUF and RXBUF.
   - Use the left (BTNL) and right (BTNR) buttons to navigate through the pages.
   - Use the up button (BTNU) to switch between displaying TXBUF and RXBUF.

## Project Report
The project report includes:
- Detailed explanation of the design and implementation.
- RTL schematics and state diagrams for various components.
- Testbenches for verification.
- Full code appendix.

## Contact
For any questions, please contact Halil Arda Özongun at arda.ozongun@ug.bilkent.edu.tr.
