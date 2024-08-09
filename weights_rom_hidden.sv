module weights_rom_hidden (
    output logic [15:0] weights [0:783][0:9]
);
    initial begin
        $readmemh("fc1_weights.mem", weights);
    end
endmodule
