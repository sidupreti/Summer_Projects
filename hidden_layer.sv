module hidden_layer (
    input logic clk,
    input logic reset,
    input logic [783:0] inputs, // 784 inputs (flattened 28x28 pixel image)
    input logic [15:0] weights_hidden [0:783][0:9], // Weights ROM for hidden layer
    input logic [15:0] biases_hidden [0:9], // Biases ROM for hidden layer
    input logic [9:0] hidden_mac_valid,
    output logic [15:0] hidden_mac_out [0:9], // Output from hidden layer MAC units
    output logic [15:0] hidden_relu_out [0:9], // Output from hidden layer ReLU units
    output logic [9:0] hidden_relu_valid
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : hidden_layer_neurons
            mac_unit mac_hidden (
                .clk(clk),
                .reset(reset),
                .inputs(inputs),
                .weights(weights_hidden[i]),
                .bias(biases_hidden[i]),
                .valid(hidden_mac_valid[i]),
                .mac_out(hidden_mac_out[i])  // Added hidden_mac_out
            );

            relu_unit relu_hidden (
                .clk(clk),
                .reset(reset),
                .mac_in(hidden_mac_out[i]), // Takes input from hidden_mac_out
                .valid_in(hidden_mac_valid[i]),
                .valid_out(hidden_relu_valid[i]),
                .relu_out(hidden_relu_out[i])
            );
        end
    endgenerate
endmodule
