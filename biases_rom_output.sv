module biases_rom_output (
    output logic [15:0] biases [0:9]
);
    initial begin
        $readmemh("fc2_biases.mem", biases);
    end
endmodule
