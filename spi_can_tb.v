module SPI_Master_tb;

    reg clk_50MHz;
    reg reset_n;
    reg start;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire done;
    wire sending;
    wire MOSI;
    reg MISO;
    wire SCK;
    wire CS;

    // Instantiate the SPI Master Module
    SPI_Master dut (
        .clk_50MHz(clk_50MHz),
        .reset_n(reset_n),
        .start(start),
        .data_in(data_in),
        .data_out(data_out),
        .done(done),
        .sending(sending),
        .MOSI(MOSI),
        .MISO(MISO),
        .SCK(SCK),
        .CS(CS)
    );

  
    always #10 clk_50MHz = ~clk_50MHz;

    initial begin
        // Initialize Inputs
        clk_50MHz = 0;
        reset_n = 0;
        start = 0;
        data_in = 8'b10010011 ;
        MISO = 1'b0;  

        
        #10 reset_n = 1;  // Release Reset

        
        #30 start = 1;  
         
       wait(done);
        
       
        $display("SPI Transmission Completed!");
        $display("Sent Data: %b", data_in);
        $display("Received Data: %b", data_out);
        $display("CS: %b, Done: %b, Sending: %b", CS, done, sending);

       
       # 10000 $finish;
    end

    
    initial begin
        $monitor("Time=%0t | CS=%b | SCK=%b | MOSI=%b | MISO=%b | Done=%b | Sending=%b | Data Out=%b", 
                  $time, CS, SCK, MOSI, MISO, done, sending, data_out);
    end
initial begin
 $dumpfile("SPI_CAN.vcd");
 $dumpvars(0,SPI_Master_tb);
end
endmodule
