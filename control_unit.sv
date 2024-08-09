module control_unit(
    input logic clk,
    input logic reset,
    output logic [9:0] hidden_mac_valid,
    output logic [9:0] hidden_relu_valid,
    output logic [9:0] output_mac_valid,
    output logic [9:0] output_relu_valid
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            hidden_mac_valid <= 10'b0;
            hidden_relu_valid <= 10'b0;
            output_mac_valid <= 10'b0;
            output_relu_valid <= 10'b0;
        end else begin
            hidden_mac_valid <= 10'b1111111111; // Enable all hidden layer MAC units
            hidden_relu_valid <= hidden_mac_valid; // Enable all ReLU units after MAC
            output_mac_valid <= hidden_relu_valid; // Enable all output layer MAC units
            output_relu_valid <= output_mac_valid; // Enable all output layer ReLU units
        end
    end
endmodule
