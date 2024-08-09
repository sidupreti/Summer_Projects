module top_level(
    input logic clk,
    input logic reset,
    input logic [783:0] inputs, // 784 inputs (flattened 28x28 image)
    output logic [3:0] recognized_digit // 4-bit output representing the recognized digit (0-9)
);

    // Internal signals
    logic [15:0] hidden_mac_out [0:9]; // Output from hidden layer MAC units
    logic [15:0] hidden_relu_out [0:9]; // Output from hidden layer ReLU units
    logic [15:0] output_relu_out [0:9]; // Output from output layer ReLU units
    logic [15:0] weights_hidden [0:783][0:9]; // Weights ROM for hidden layer
    logic [15:0] biases_hidden [0:9]; // Biases ROM for hidden layer
    logic [15:0] weights_output [0:9][0:9]; // Weights ROM for output layer
    logic [15:0] biases_output [0:9]; // Biases ROM for output layer
    logic [9:0] hidden_mac_valid;
    logic [9:0] hidden_relu_valid;
    logic [9:0] output_mac_valid;
    logic [9:0] output_relu_valid;

    // Instantiating the ROMs for weights and biases
    weights_rom_hidden weights_inst_hidden(.weights(weights_hidden));
    biases_rom_hidden biases_inst_hidden(.biases(biases_hidden));
    weights_rom_output weights_inst_output(.weights(weights_output));
    biases_rom_output biases_inst_output(.biases(biases_output));

    // Instantiating the Control Unit
    control_unit ctrl (
        .clk(clk),
        .reset(reset),
        .hidden_mac_valid(hidden_mac_valid),
        .hidden_relu_valid(hidden_relu_valid),
        .output_mac_valid(output_mac_valid),
        .output_relu_valid(output_relu_valid)
    );

    // Instantiating Hidden Layer
    hidden_layer hidden_layer_inst (
        .clk(clk),
        .reset(reset),
        .inputs(inputs),
        .weights_hidden(weights_hidden),
        .biases_hidden(biases_hidden),
        .hidden_mac_valid(hidden_mac_valid),
        .hidden_mac_out(hidden_mac_out), // Connect hidden_mac_out to top-level
        .hidden_relu_out(hidden_relu_out),
        .hidden_relu_valid(hidden_relu_valid)
    );

    // Instantiating Output Layer
    output_layer output_layer_inst (
        .clk(clk),
        .reset(reset),
        .hidden_relu_out(hidden_relu_out),
        .weights_output(weights_output),
        .biases_output(biases_output),
        .output_mac_valid(output_mac_valid),
        .output_relu_out(output_relu_out),
        .output_relu_valid(output_relu_valid)
    );

    // Argmax logic to determine the recognized digit
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            recognized_digit <= 4'd0;
        end else begin
            recognized_digit <= 4'd0;
            for (i = 1; i < 10; i = i + 1) begin
                if (output_relu_out[i] > output_relu_out[recognized_digit]) begin
                    recognized_digit <= i;
                end
            end
        end
    end

endmodule
