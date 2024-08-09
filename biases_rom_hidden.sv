module biases_rom_hidden (
    output logic [15:0] biases [0:9]
);
    initial begin
        $readmemh("fc1_biases.mem", biases);
    end
endmodule
