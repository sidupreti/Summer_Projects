module relu_unit(
    input logic clk,
    input logic reset,
    input logic [15:0] mac_in,
    input logic valid_in,
    output logic valid_out,
    output logic [15:0] relu_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            relu_out <= 16'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            relu_out <= (mac_in[15] == 1'b0) ? mac_in : 16'b0; // ReLU function
            valid_out <= 1'b1;
        end
    end
endmodule
