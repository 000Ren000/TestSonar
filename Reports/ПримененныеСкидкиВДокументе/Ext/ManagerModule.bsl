﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ОтключитьОтчет(ОписаниеОтчета);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПримененныеСкидкиВДокументе)
			И ПравоДоступа("Просмотр", Метаданные.Справочники.СкидкиНаценки)
			И ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ПримененныеСкидкиВДокументе.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Примененные скидки'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаОтчет,"ХозяйственнаяОперация",
			Перечисления.ХозяйственныеОперации.ПоставкаПодПринципала, ВидСравненияКомпоновкиДанных.НеРавно);
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецЕсли