#include <iostream>
#include <deque>

int main() {
   const int min_d = 1;
   const int max_d = 1000000;
   std::deque<int> d;
   // int input[] = {3, 8, 9, 1, 2, 5, 4, 6, 7}; // example
   int input[] = {1, 5, 6, 7, 9, 4, 8, 2, 3};
   d.insert(d.begin(), input, input + 9);
   for (int i = 10; i <= max_d; i++) {
      d.push_back(i);
   }

   for (int move = 1; move <= 10000000; move++) {
      std::deque<int>::iterator ptr = d.begin();
      int top = *ptr++;
      int label = top;
      int p[3];
      p[0] = *ptr++;
      p[1] = *ptr++;
      p[2] = *ptr++;
      d.erase(d.begin(), ptr);
      do {
         label--;
         if (label < min_d) label = max_d;
      } while (label == p[0] || label == p[1] || label == p[2]);

      for (std::deque<int>::iterator it=d.begin(); it!=d.end(); ++it) {
         if (label == *it) {
            d.insert(++it, p, p+3);
            break;
         }
      }
      d.push_back(top);
   }
   std::cout << "d contains:";
   std::deque<int>::iterator it = d.begin();
   while (*it != 1) it++;
   std::cout << ' ' << *++it << ' ' << *++it << '\n';
}
// jef@domicile:~/aoc/aoc2020$ g++ -O4 aoc23b.C && time ./a.out
// d contains: 36807 312400

// real    54m57,297s
// user    54m56,363s
// sys     0m0,132s

