module weights_rom_output (
    output logic [15:0] weights [0:9][0:9]
);
    initial begin
        $readmemh("fc2_weights.mem", weights);
    end
endmodule
