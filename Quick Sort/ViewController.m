//
//  ViewController.m
//  Quick Sort
//
//  Created by error on 10.04.17.
//
//

#import "ViewController.h"

typedef NSMutableArray<NSNumber*> ASIntArray;

@implementation ViewController

// процедура быстрой сортировки
- (void) quickSort:(ASIntArray *)array from:(NSInteger)from to:(NSInteger)to{
    NSInteger i = from, j = to;
    // средний эллемент
    NSNumber *n = array[(from + to) / 2], *t;

    // главный цикл
    do{
        // пропускаем все элементы меньшие среднего ->
        while([array[i] intValue] < [n intValue])
            i++;
        
        // пропускаем все элементы больше среднего <-
        while([array[j] intValue] > [n intValue])
            j--;
        
        // меняем местами
        if(i <= j){
            t = array[i];
            array[i] = array[j];
            array[j] = t;
            i++;
            j--;
        }
    }
    while(i <= j);
    
    // рекурсивные вызовы
    if(from < j)
        [self quickSort:array from:from to:j];
    if(to > i)
        [self quickSort:array from:i to:to];
}

// враппер для quickSort
- (void) quickSort:(ASIntArray *)array{
    if(array.count > 0)
        [self quickSort:array from:0 to:array.count - 1];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    // выходим если событие инициировано не rawArray
    if(notification.object != rawArray)
        return;
    
    // вводим raw из rawArray textfield
    NSString *raw = rawArray.stringValue;
    
    // выделяем память под массив
    ASIntArray *array = [[ASIntArray alloc] init];
    
    // создаем сканер для сторки raw
    NSScanner *scanner = [NSScanner scannerWithString:raw];
    
    // продолжаем считывть числа, пока есть входные символы
    @try {
        while ([scanner isAtEnd] == NO){
            int n;
            if([scanner scanInt:&n]){
                [array addObject:[NSNumber numberWithInt:n]];
                if([scanner scanString:@"," intoString:nil] == NO && [scanner isAtEnd] == NO)
                    // если не найдена запятая после числа, но есть еще символы во входном потоке
                    @throw [NSException exceptionWithName:@"fail" reason:nil userInfo:nil];
            }
            else
                // если обнаружен постороний символ
                @throw [NSException exceptionWithName:@"fail" reason:nil userInfo:nil];
        }
    } @catch (NSException *exception) {
        // сообщаем в какой позиции ошибка ввода
        sortedArray.stringValue = [NSString stringWithFormat:@"Error in pos: %lu", [scanner scanLocation]];
        return;
    }
    
    // сортируем
    [self quickSort:array];
    
    // преобразуем массив в строку
    NSMutableString *sorted = [NSMutableString string];
    for(int i = 0; i < array.count; i++){
        [sorted appendString:[array[i] stringValue]];
        if(i != array.count - 1)
            [sorted appendString:@", "];
    }
    
    // выводим sorted в sortedArray textfield
    sortedArray.stringValue = sorted;
}


@end
