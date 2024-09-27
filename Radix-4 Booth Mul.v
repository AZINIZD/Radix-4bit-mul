//Radix-4 Booth Multiplier

module multiplier (
    input clk,
    input reset,
    input [15:0] x,
    input [15:0] y,
    output reg [31:0] out
);
    reg [2:0] c = 0;
    reg [31:0] pp = 0; // partial products
    reg [31:0] spp = 0; // shifted partial products
    reg [31:0] prod = 0;
    reg [15:0] i = 0, j = 0;
    reg flag = 0;
    reg temp = 0;
    wire [15:0] inv_x; // two's complement of x

    assign inv_x = (~x) + 1'b1; // two's complement

    always @(posedge clk) begin
        if (reset) begin
            out = 0;
            c = 0;
            pp = 0;
            flag = 0;
            spp = 0;
            i = 0;
            j = 0;
            prod = 0;
        end else begin
            if (!flag) begin
                c = {y, y, 1'b0}; // initializing c with y
                flag = 1;
            end
            case (c)
                3'b000, 3'b111: begin
                    if (i < 8) begin
                        i = i + 1;
                        c = {y[2*i+1], y[2*i], y[2*i-1]};
                    end else begin
                        c = 3'bxxx;
                    end
                end
                3'b001, 3'b010: begin
                    if (i < 8) begin
                        i = i + 1;
                        c = {y[2*i+1], y[2*i], y[2*i-1]};
                        pp = {{16{x}}, x}; // generating partial product
                        if (i == 1'b1) 
                            prod = pp;
                        else begin
                            temp = pp;
                            j = i - 1;
                            j = j << 1;
                            spp = pp << j; // shifting partial product
                            prod = prod + spp; // adding shifted partial product
                        end
                    end
                end
                // Additional cases for other values of c can be added here
            endcase
        end
    end
endmodule