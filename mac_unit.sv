module mac_unit #(
    parameter INPUT_WIDTH = 784 // Default to 784 for the hidden layer
)(
    input logic clk,
    input logic reset,
    input logic [(INPUT_WIDTH*16)-1:0] inputs, // INPUT_WIDTH 16-bit inputs
    input logic [15:0] weights [0:INPUT_WIDTH-1], // INPUT_WIDTH weights (16-bit fixed-point)
    input logic [15:0] bias,
    input logic valid,
    output logic [15:0] mac_out
);
    logic [31:0] accumulator;
    integer j;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= 32'b0;
        end else if (valid) begin
            accumulator = 32'b0;
            for (j = 0; j < INPUT_WIDTH; j = j + 1) begin
                if (inputs[j*16 +: 16] != 0) begin
                    accumulator = accumulator + weights[j];
                end
            end
            // After all accumulations are done, add the bias
            accumulator <= accumulator + bias;
            mac_out <= accumulator[31:16]; // Assign the most significant bits to the output
        end
    end
endmodule
