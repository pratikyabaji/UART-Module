module uart_rx(
  input wire clk,
  input wire rx,

  output reg [7:0] data_out,
  output reg rx_flag,
  output reg rx_valid
);

reg [10:0] count;
reg [7:0] data_bits;
reg parity_bit;
reg stop_bit;

always @(posedge clk) begin
  if (count == 0 && rx == 0)
    count <= 1;
  else if (count > 0 && count < 11) begin
    count <= count + 1;
    data_bits[count - 1] <= rx;
  end else if (count == 11) begin
    count <= 0;
    parity_bit <= rx;
  end
end

always @(posedge clk) begin
  if (count == 0)
    rx_flag <= 0;
  else if (count == 11) begin
    stop_bit <= rx;
    rx_flag <= 1;
	 if(parity_bit == ^data_bits) 
		rx_valid <= 1'b1;
	 else
		rx_valid <= 1'b0;
  end
end

always @(posedge clk) begin
  if (count == 0)
    data_out <= 8'b0;
  else if (count == 11)
    data_out <= data_bits;
end

endmodule
