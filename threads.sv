`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2024 15:26:20
// Design Name: 
// Module Name: threads
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//named events how blocking of events we learned
module threads;
     event ev;
        initial 
            begin
                $display("the before event");
                #10;
                $display("the just befor triggering event");
                ->ev;
                
            end
         initial 
            begin
                $display("the before event");
                #10;
                 $display("the after event");
                wait(ev.triggered);
                 $display("the after event22");                
            end
endmodule

// using semaphore we learned process/thread  synchronization  and hold the first thread and stopped from execution

module semaphore;
semaphore sem;
class driver;
     task send();
     fork  
           begin
             sem.get(2);
             $display("it will execute1234");
             sem.put(0);
           end
            begin
             sem.get(1);
             $display("it will execute");
             sem.put(1);
           end
        join            
     endtask:send
endclass:driver


     driver dr[2];
     
     initial 
          begin
              foreach(dr[i])
                  dr[i]= new();
              sem = new(1);
          fork 
             dr[0].send();
             dr[1].send();
          join
          end
endmodule



