module mult #(parameter DATA_WIDTH = 14, OUTPUT_WIDTH = 28) (
    input wire [DATA_WIDTH-1:0] multiplicand,
    input wire [DATA_WIDTH-1:0] multiplier,

    output reg [OUTPUT_WIDTH-1:0] result_reg
);

reg [DATA_WIDTH-1:0] Opcand, Oper;
reg [28-1:0] result;

always @(*) begin
    case ({multiplicand[DATA_WIDTH-1], multiplier[DATA_WIDTH-1]})
        2'b00: begin
            Opcand = multiplicand;
            Oper   = multiplier;
            result = Opcand * Oper;
        end 
        2'b01: begin
            Opcand = multiplicand;
            Oper   = (1'b0 - multiplier);
            result = (1'b0 - (Opcand * Oper));
        end
        2'b10: begin
            Opcand = (1'b0 - multiplicand);
            Oper   = multiplier;
            result = (1'b0 - (Opcand * Oper));
        end
        2'b11: begin
            Opcand = (1'b0 - multiplicand);
            Oper   = (1'b0 - multiplier);
            result = Opcand * Oper;
        end
        default: begin
            Opcand = multiplicand;
            Oper   = multiplier;
            result = Opcand * Oper;
        end
    endcase
end

always @(*) begin
    result_reg = result;
end
    
endmodule


module add (
    input wire cin,
    input wire [27:0] A, B,
    output reg [27:0] S
);

always @(*) begin
    S = A + B + cin;
end

endmodule
