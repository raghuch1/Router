`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2024 01:45:28
// Design Name: 
// Module Name: BinarySearch
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


module BinarySearch;
function automatic int binarySearch(int array[],int size,int target);
    int low = 0;
    static int high;
    high =size-1;

    while (low <= high) 
    begin
      int mid = low + (high - low)/2;
      // If target is greater, ignore left half
      if (array[mid]==target)
            return mid;
      // If target is smaller, ignore right half
      else if(array[mid] > target)   
         high = mid - 1;       
      else 
          low = mid + 1;
          end 
     return -1;
  endfunction:binarySearch
  initial begin
    int array[10] = '{1, 3, 5, 7, 9, 11, 13, 15, 17, 19}; // Sorted array
    int target = 11; // Variable to search for
    int index;  
    index = binarySearch(array,10,target);   
         $display("Target %d ", index);   
   if (index != -1)
      $display("Target %d found at index %d", target, index);
    else
      $display("Target %d not found", target);
      
  end     
endmodule
