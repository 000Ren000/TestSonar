﻿#Область СлужебныйПрограммныйИнтерфейс

// Выполняет нормализацию значений кодов маркировки для приведения к значениям,
// аналогичным получаемым из сервиса.
// 
// Параметры:
// 	УзелДерева               - ДеревоЗначений,СтрокаДереваЗначений - данные дерева.
// 	ПараметрыНормализацииКМ  - См. РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки.
// 	ИсходныеЗначенияШрихкода - Соответствие из КлючИЗначение - Соответствие строк и исходных значений для восстановления.
Процедура НормализоватьДеревоЗначенийРекурсивно(УзелДерева, ПараметрыНормализацииКМ, ИсходныеЗначенияШрихкода) Экспорт
	
	Для Каждого СтрокаДерева Из УзелДерева.Строки Цикл
		
		НормализоватьДеревоЗначенийРекурсивно(СтрокаДерева, ПараметрыНормализацииКМ, ИсходныеЗначенияШрихкода);
		
		Если ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияМОТП(СтрокаДерева.ВидПродукции)
			Или СтрокаДерева.ВидПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС Тогда
			
			Если СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская Тогда
				
				Если ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияМОТП(СтрокаДерева.ВидПродукции) Тогда
					ПараметрыНормализацииКМ.НачинаетсяСоСкобки = Ложь;
				Иначе
					ПараметрыНормализацииКМ.НачинаетсяСоСкобки = Истина;
				КонецЕсли;
				ПараметрыНормализацииКМ.ВключатьМРЦ          = Ложь;
				ПараметрыНормализацииКМ.ВключатьСрокГодности = Истина;
				
			ИначеЕсли СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Групповая
				Или СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Набор Тогда
				
				ПараметрыНормализацииКМ.НачинаетсяСоСкобки   = Истина;
				ПараметрыНормализацииКМ.ВключатьМРЦ          = Ложь;
				ПараметрыНормализацииКМ.ВключатьСрокГодности = Ложь;
				
			ИначеЕсли СтрокаДерева.ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая
				И ОбщегоНазначенияИСПовтИсп.ЭтоПродукцияИСМП(СтрокаДерева.ВидПродукции, Истина)
				И СтрокаДерева.ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_128 Тогда
				
				ПараметрыНормализацииКМ.НачинаетсяСоСкобки = Ложь;
				
			Иначе
				Продолжить;
			КонецЕсли;
			
		Иначе
			Продолжить;
		КонецЕсли;
		
		КодМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
			СтрокаДерева,
			СтрокаДерева.ВидПродукции,
			ПараметрыНормализацииКМ);
		
		Если СтрокаДерева[ПараметрыНормализацииКМ.ИмяСвойстваКодМаркировки] <> КодМаркировки Тогда
			ИсходныеЗначенияШрихкода.Вставить(СтрокаДерева, СтрокаДерева[ПараметрыНормализацииКМ.ИмяСвойстваКодМаркировки]);
			СтрокаДерева[ПараметрыНормализацииКМ.ИмяСвойстваКодМаркировки] = КодМаркировки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
