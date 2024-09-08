﻿////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции работы с выгрузкой и загрузкой из Excel
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Создать присоединенный файл excel
//
// Параметры:
//  ДокументСсылка		 - ДокументСсылка.ПланЗакупок - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланПродаж - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланОстатков - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланПродажПоКатегориям - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланПроизводства - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланСборкиРазборки - ссылка на документ для которого создается присоединенный файл.
//  					 - ДокументСсылка.ПланВнутреннихПотреблений - ссылка на документ для которого создается присоединенный файл.
//  ИдентификаторФормы	 - УникальныйИдентификатор	 - идентификатор формы.
// 
// Возвращаемое значение:
//  Структура - Параметры созданного присоединенного файла.
Функция СоздатьПрисоединенныйФайлExcel(ДокументСсылка, ИдентификаторФормы) Экспорт 
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументСсылка);
	
	Попытка
		Возврат Менеджер.СоздатьПрисоединенныйФайлExcel(ДокументСсылка, ИдентификаторФормы);
	Исключение
		Возврат Неопределено;
	КонецПопытки; 
	
КонецФункции 

#КонецОбласти