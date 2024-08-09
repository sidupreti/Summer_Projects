module output_layer (
    input logic clk,
    input logic reset,
    input logic [15:0] hidden_relu_out [0:9], // Inputs from hidden layer ReLU units
    input logic [15:0] weights_output [0:9][0:9], // Weights ROM for output layer
    input logic [15:0] biases_output [0:9], // Biases ROM for output layer
    input logic [9:0] output_mac_valid,
    output logic [15:0] output_relu_out [0:9], // Output from output layer ReLU units
    output logic [9:0] output_relu_valid
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : output_layer_neurons
            mac_unit #(.INPUT_WIDTH(10)) mac_output (
                .clk(clk),
                .reset(reset),
                .inputs({hidden_relu_out[0], hidden_relu_out[1], hidden_relu_out[2], hidden_relu_out[3],
                         hidden_relu_out[4], hidden_relu_out[5], hidden_relu_out[6], hidden_relu_out[7],
                         hidden_relu_out[8], hidden_relu_out[9]}),
                .weights(weights_output[i]),
                .bias(biases_output[i]),
                .valid(output_mac_valid[i]),
                .mac_out(output_relu_out[i]) // Output of MAC is directly fed to ReLU
            );

            relu_unit relu_output (
                .clk(clk),
                .reset(reset),
                .mac_in(output_relu_out[i]), // Takes input from the MAC output
                .valid_in(output_mac_valid[i]),
                .valid_out(output_relu_valid[i]),
                .relu_out(output_relu_out[i])
            );
        end
    endgenerate
endmodule
