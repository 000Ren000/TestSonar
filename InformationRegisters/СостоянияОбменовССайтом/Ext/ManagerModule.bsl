﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьСостоянияОбменовССайтами() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК Настройка
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	 НЕ ОбменССайтом.Ссылка = &ЭтотУзел";
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		
		НаборЗаписейОбменДанными = РегистрыСведений.СостоянияОбменовДанными.СоздатьНаборЗаписей();
		НаборЗаписейОбменДанными.Отбор.УзелИнформационнойБазы.Установить(Выборка.Настройка);
		НаборЗаписейОбменДанными.Прочитать();
		
		НаборЗаписейОбменССайтом = СоздатьНаборЗаписей(); // РегистрыСведений.СостоянияОбменовССайтом избыточно
		НаборЗаписейОбменССайтом.Отбор.НастройкаОбменаССайтом.Установить(Выборка.Настройка);
		НаборЗаписейОбменССайтом.Прочитать();
		
		Для Каждого ЗаписьОбменаДанными Из НаборЗаписейОбменДанными Цикл
			
			ЗаписьОбменаССайтом = НаборЗаписейОбменССайтом.Добавить();
			 
			ЗаполнитьЗначенияСвойств(ЗаписьОбменаССайтом, ЗаписьОбменаДанными);
			
			ЗаписьОбменаССайтом.НастройкаОбменаССайтом = ЗаписьОбменаДанными.УзелИнформационнойБазы;
			
			Если ЗаписьОбменаДанными.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных Тогда
				ДействиеПриОбмене = Перечисления.ДействияПриОбменеССайтом.ВыгрузкаДанных;
			ИначеЕсли ЗаписьОбменаДанными.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда
				ДействиеПриОбмене = Перечисления.ДействияПриОбменеССайтом.ЗагрузкаДанных;
			КонецЕсли;
			ЗаписьОбменаССайтом.ДействиеПриОбмене = ДействиеПриОбмене;
			
			Если ЗаписьОбменаДанными.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Выполнено Тогда
				Результат = Перечисления.РезультатыОбменаССайтом.Выполнено;
			ИначеЕсли ЗаписьОбменаДанными.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями Тогда
				Результат = Перечисления.РезультатыОбменаССайтом.ВыполненоСПредупреждениями;
			ИначеЕсли ЗаписьОбменаДанными.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Ошибка Тогда
				Результат = Перечисления.РезультатыОбменаССайтом.Ошибка;
			КонецЕсли;
			ЗаписьОбменаССайтом.РезультатВыполненияОбмена = Результат;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейОбменССайтом, Истина, Ложь, Ложь);
		
		НаборЗаписейОбменДанными.Очистить();
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейОбменДанными, Истина, Ложь, Ложь);
		
		НаборЗаписейСостоянияУспешныхОбменов = РегистрыСведений.СостоянияУспешныхОбменовДанными.СоздатьНаборЗаписей();
		НаборЗаписейСостоянияУспешныхОбменов.Отбор.УзелИнформационнойБазы.Установить(Выборка.Настройка);
		НаборЗаписейСостоянияУспешныхОбменов.Прочитать();
		
		НаборЗаписейУспешныеОбменыССайтом = РегистрыСведений.УспешныеОбменыССайтом.СоздатьНаборЗаписей();
		НаборЗаписейУспешныеОбменыССайтом.Отбор.НастройкаОбменаССайтом.Установить(Выборка.Настройка);
		НаборЗаписейУспешныеОбменыССайтом.Прочитать();
		
		Для Каждого ЗаписьОбменаДанными Из НаборЗаписейСостоянияУспешныхОбменов Цикл
			
			ЗаписьОбменаССайтом = НаборЗаписейУспешныеОбменыССайтом.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьОбменаССайтом, ЗаписьОбменаДанными);
			
			ЗаписьОбменаССайтом.НастройкаОбменаССайтом = ЗаписьОбменаДанными.УзелИнформационнойБазы;
			
			Если ЗаписьОбменаДанными.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных Тогда
				ДействиеПриОбмене = Перечисления.ДействияПриОбменеССайтом.ВыгрузкаДанных;
			ИначеЕсли ЗаписьОбменаДанными.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда
				ДействиеПриОбмене = Перечисления.ДействияПриОбменеССайтом.ЗагрузкаДанных;
			КонецЕсли;
			ЗаписьОбменаССайтом.ДействиеПриОбмене = ДействиеПриОбмене;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейУспешныеОбменыССайтом, Истина, Ложь, Ложь);
		
		НаборЗаписейСостоянияУспешныхОбменов.Очистить();
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейСостоянияУспешныхОбменов, Истина, Ложь, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
