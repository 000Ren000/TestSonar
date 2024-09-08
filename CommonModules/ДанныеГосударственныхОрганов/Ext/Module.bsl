﻿#Область ПрограммныйИнтерфейс


// Возвращается код региона в соответствии с адресным классификатором по коду налоговой инспекции.
//
// Параметры:
//	КодНалоговогоОргана - Строка - код налогового органа.
//
// Возвращаемое значение:
//   Строка - код региона по адресному классификатору - см. КодСубъектаРФ в РегистрыСведений.АдресныеОбъекты.КлассификаторСубъектовРФ()
//
Функция КодРегионаПоКодуНалоговогоОргана(Знач КодНалоговогоОргана) Экспорт
	
	КодРегиона = "";
	
	Если СтрДлина(КодНалоговогоОргана) < 2 Тогда
		Возврат КодРегиона;	
	КонецЕсли;	
	
	КодРегиона = Лев(КодНалоговогоОргана, 2);
	
	// 99 - код г.Байконур и одновременно код инспекций по крупнейшим налогоплательщикам.
	// 9901 - код местной инспекции, все остальные - инспекции по крупнейшим налогоплательщикам - находятся в Москве
	Если КодРегиона = "99" И КодНалоговогоОргана <> "9901" Тогда
		КодРегиона = "77";
	КонецЕсли;	
		
	Возврат КодРегиона;
	
КонецФункции


#КонецОбласти
