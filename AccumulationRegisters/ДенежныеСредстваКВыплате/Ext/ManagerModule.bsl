﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
//  см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваКВыплате.Имя;
	ИмяТаблицыИзменений = "ДвиженияДенежныеСредстваКВыплатеИзменение"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Заполняет сведения об обработчиках обновления.
// 
// Параметры:
//  Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	//++ Локализация

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ДенежныеСредстваКВыплате.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.17.17";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("4d1821e9-c00a-46f5-958b-4cb6507b13a8");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ДенежныеСредстваКВыплате.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий =
		НСтр("ru = 'Изменение операции ""Оплата самозанятому"" на операцию ""Оплата поставщику"" в регистре накопления ""Денежные средства к выплате"".'");
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваКВыплате.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваКВыплате.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

	//-- Локализация

КонецПроцедуры

//++ Локализация

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки; // см. ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляМногопоточнойОбработки
	ПараметрыВыборки.ПолныеИменаОбъектов = ТипыДокументовКОбработке();
	ПараметрыВыборки.ПолныеИменаРегистров = Метаданные.РегистрыНакопления.ДенежныеСредстваКВыплате.ПолноеИмя();
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПараметрыВыборки.ПолныеИменаРегистров;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДвиженияРегистра.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКВыплате КАК ДвиженияРегистра
		|ГДЕ
		|	ДвиженияРегистра.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.УдалитьОплатаСамозанятому)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор"), ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры обработчика:
//   * ВерсияПодсистемыНаНачалоОбновления - Строка - версия подсистемы.
//   * ИмяОбработчика - Строка - имя обработчика.
//   * ОбновляемыеДанные - Структура.
//   * ОбработкаЗавершена - Булево, Неопределено - признак завершения обработки.
//   * Очередь - Число - очередь.
//   * ПрогрессВыполнения - Структура:
//     ** ВсегоОбъектов - Число - всего обработано объектов.
//     ** ОбработаноОбъектов - Число - обработано объектов.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	ПолноеИмяРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваКВыплате.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		
		Параметры.ОбработкаЗавершена =
			ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
		
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	ИсключенияПриОбновлении = Новый Массив;
	
	СписокОписаний = Новый Массив;
	СписокОписаний.Добавить(НСтр("ru = 'Не удалось заменить операцию ""Оплата самозанятому"" на операцию ""Оплата поставщику"" в регистре накопления ""Денежные средства к выплате"".'"));
	
	Для Каждого СтрокаТаблицы Из ОбновляемыеДанные Цикл
		
		ПричинаИсключения = 0;
		Рекомендация = "";
		
		НачатьТранзакцию();
		
		Попытка
			
			ПричинаИсключения = 1; // Блокировка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", СтрокаТаблицы.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
				
			ПричинаИсключения = 2; // ПлохиеДанные
			Рекомендация = НСтр("ru = 'Перепроведите документ вручную.'");
			
			НаборЗаписейИзменен = Ложь;

			НаборЗаписей = РегистрыНакопления.ДенежныеСредстваКВыплате.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(СтрокаТаблицы.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				
				Если Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.УдалитьОплатаСамозанятому Тогда
					Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику;
					НаборЗаписейИзменен = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
			ПричинаИсключения = 3; // Запись
			
			Если НаборЗаписейИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ДополнительныеПараметры);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), СтрокаТаблицы.Регистратор);
			
			Если ПричинаИсключения = 2 Тогда
				
				ОписаниеПроблемы = ОбновлениеИнформационнойБазыУТ.ПроблемаСДанными(
					СтрокаТаблицы.Регистратор, Рекомендация, ИнформацияОбОшибке());
				ИсключенияПриОбновлении.Добавить(ОписаниеПроблемы);
				
			ИначеЕсли ПричинаИсключения = 3 Тогда
				
				ОбновлениеИнформационнойБазыУТ.ЗаписатьПлохиеДанные(
					ИсключенияПриОбновлении, ОбъектовОбработано, Параметры);
				ВызватьИсключение СтрСоединить(СписокОписаний, Символы.ПС);
				
			КонецЕсли;
			
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена =
		ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		
		СписокОписаний.Добавить(НСтр("ru = 'Всего пропущено: %1'"));
		ТекстСообщения = СтрШаблон(СтрСоединить(СписокОписаний, Символы.ПС), ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
		
	Иначе
		
		ШаблонСообщения = НСтр("ru = 'Обработана порция записей регистра накопления ""Денежные средства к выплате"": %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			ТекстСообщения);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыУТ.ЗаписатьПлохиеДанные(ИсключенияПриОбновлении, ОбъектовОбработано, Параметры);
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

Функция ТипыДокументовКОбработке()

	ИменаДокументов = Новый Массив;
	
	
	ИменаДокументов.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств.ПолноеИмя());
	
	Возврат СтрСоединить(ИменаДокументов, ",");

КонецФункции

//-- Локализация

#КонецОбласти

#КонецЕсли