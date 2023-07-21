module uart_tx(
  input wire clk,
  input wire reset,
  input wire [7:0] data_in,
  input wire state,

  output reg tx,
  output reg tx_flag
);
  reg [3:0] count;
  reg [7:0] data_bits;
  reg parity_bit;
  reg stop_bit;

  always @(posedge clk or posedge reset) begin
    if (reset)
      count <= 0;
    else if (state) 
	 begin
      count <= 1;
      data_bits  <=  data_in;
      parity_bit <= ^data_in;
      stop_bit   <= 1'b1;
    end 
	 else if (count < 11) begin
      count <= count + 1;
    end 
	 else 
	 begin
      count <= 0;
    end
  end

  always @(posedge clk) 
  begin
	case (count)
		0: tx <= 1'b1; // ideal state
		1: tx <= 1'b0; // state bit
		2: tx <= data_bits[0]; // data_bits 0
		3: tx <= data_bits[1]; // data_bits 1
		4: tx <= data_bits[2]; // data_bits 2
		5: tx <= data_bits[3]; // data_bits 3
		6: tx <= data_bits[4]; // data_bits 4
		7: tx <= data_bits[5]; // data_bits 5
		8: tx <= data_bits[6]; // data_bits 6
		9: tx <= data_bits[7]; // data_bits 7
		10: tx <= parity_bit;  // parity bit
		11: tx <= stop_bit;	  // stop bit
		default: tx <= 1'b1; // ideal state
  endcase
 end

endmodule
