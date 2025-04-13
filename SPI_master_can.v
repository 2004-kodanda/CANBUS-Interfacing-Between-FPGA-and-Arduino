module SPI_Master (
    input wire clk_50MHz,        
    input wire reset_n,        
    input wire start,        
    input wire [7:0] data_in,   
    output reg [7:0] data_out,     
    output reg done,             
    output reg sending,         
    output reg MOSI,              
    input wire MISO,           
    output reg SCK,           
    output reg CS                
);


    parameter CLK_DIV = 125;
    reg [6:0] clk_div_counter = 0;
    reg clk_400kHz = 0;

    always @(posedge clk_50MHz or negedge reset_n) begin
        if (!reset_n) begin
            clk_div_counter <= 0;
            clk_400kHz <= 0;
        end else begin
            if (clk_div_counter == (CLK_DIV / 2) - 1) begin
                clk_div_counter <= 0;
                clk_400kHz <= ~clk_400kHz;
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        end
    end

    
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    
    always @(posedge clk_400kHz or negedge reset_n) begin
        if (!reset_n) begin
            CS <= 1;
            MOSI <= 0;
            SCK <= 0;
            done <= 0;
            sending <= 0;
            bit_count <= 0;
        end else begin
            if (start && !sending) begin 
                CS <= 0;
                shift_reg <= data_in;
                bit_count <= 0;
                sending <= 1; 
                done <= 0;
            end

            if (sending) begin
                SCK <= ~SCK;
                if (SCK == 0) begin
                    MOSI <= shift_reg[7];
                end else begin
                    shift_reg <= {shift_reg[6:0], MISO};
                    bit_count <= bit_count + 1;
                end

                if (bit_count == 7 && SCK == 1) begin
                    done <= 1;
                    sending <= 0; 
                end
            end
        end
    end

    always @(posedge done) begin
        data_out <= shift_reg;
    end

endmodule
