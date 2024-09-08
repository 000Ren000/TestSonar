﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.15.35";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1d86b925-d170-44ae-9550-190d1f7da828");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	Обработчик.Комментарий = НСтр("ru = 'Перезаполняет хозяйственную операцию для документа ""Взаимозачет задолженности"" с видом операции ""Перенос долга"".
	|Исправляет хозяйственную операцию ""Погашение задолженности"" на ""Перенос аванса"" для движений зачета оплат периодом даты платежа.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.РасчетыСКлиентамиПоСрокам";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Документ.РегистраторРасчетов";
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	РасчетыСКлиентамиПоСрокам.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК РасчетыСКлиентамиПоСрокам
	|ГДЕ
	|	РасчетыСКлиентамиПоСрокам.ДокументРегистратор ССЫЛКА Документ.ВзаимозачетЗадолженности
	|		И ВЫРАЗИТЬ(РасчетыСКлиентамиПоСрокам.ДокументРегистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации В (&ВидыОпераций)
	|		И РасчетыСКлиентамиПоСрокам.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереносДолга)
	|	ИЛИ
	|		РасчетыСКлиентамиПоСрокам.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПогашениеЗадолженностиКлиента)
	|		И НАЧАЛОПЕРИОДА(РасчетыСКлиентамиПоСрокам.Период, ДЕНЬ) <> НАЧАЛОПЕРИОДА(РасчетыСКлиентамиПоСрокам.ДатаВозникновения, ДЕНЬ)
	|		И РасчетыСКлиентамиПоСрокам.Предоплата > 0 
	|		И РасчетыСКлиентамиПоСрокам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И &ЗачетОплатПоДатеПлатежа
	|";
	Запрос.УстановитьПараметр("ВидыОпераций", ВидыОпераций());
	Запрос.УстановитьПараметр("ЗачетОплатПоДатеПлатежа", Константы.ЗачетОплатПоДатеПлатежа.Получить() = 1);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам;
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.ДокументРегистратор КАК Взаимозачет
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|	И ВЫРАЗИТЬ(Движения.ДокументРегистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации В (&ВидыОпераций)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|";
		Запрос.УстановитьПараметр("Регистраторы", ОбновляемыеДанные.ВыгрузитьКолонку("Регистратор"));
		Запрос.УстановитьПараметр("ВидыОпераций", ВидыОпераций());
		Результаты = Запрос.ВыполнитьПакет();
		
		ПроблемныйРегистратор = Неопределено;
		ЗачетОплатПоДатеПлатежа = Константы.ЗачетОплатПоДатеПлатежа.Получить();
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.ИсточникДанных = ОбновляемыеДанные;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Регистратор", "Регистратор");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			ДокументыВзаимозачетов = Результаты[0].Выгрузить().ВыгрузитьКолонку("Взаимозачет");
			ВыборкаПоРегистратору = Результаты[1].Выбрать();
			Пока ВыборкаПоРегистратору.Следующий() Цикл
				
				ПроблемныйРегистратор = ВыборкаПоРегистратору.Регистратор;
				
				Набор = РегистрыНакопления.РасчетыСКлиентамиПоСрокам.СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(ВыборкаПоРегистратору.Регистратор);
				Набор.Прочитать();
				НаборТЗ = Набор.Выгрузить();
				
				ЕстьИзменения = Ложь;
				Для Каждого Запись Из НаборТЗ Цикл
					Если Запись.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПереносДолга 
						И ДокументыВзаимозачетов.Найти(Запись.ДокументРегистратор) <> Неопределено Тогда
							Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереносДолга;
							ЕстьИзменения = Истина;
					КонецЕсли;
					Если Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПогашениеЗадолженностиКлиента
						И НачалоДня(Запись.Период) <> НачалоДня(Запись.ДатаВозникновения)
						И Запись.Предоплата > 0 
						И Запись.ВидДвижения = ВидДвиженияНакопления.Расход
						И ЗачетОплатПоДатеПлатежа Тогда
						
						Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереносАванса;
						
						СтруктураПоиска = Новый Структура("ДокументРегистратор,ВидДвижения,Долг",
							Запись.ДокументРегистратор,Запись.ВидДвижения,Запись.Предоплата);
						СтрокиДолга = НаборТЗ.НайтиСтроки(СтруктураПоиска);
						СтрокиДолга[0].ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереносАванса;
						
						ЕстьИзменения = Истина;
					КонецЕсли;
				КонецЦикла;
				
				Если ЕстьИзменения Тогда
					Набор.Загрузить(НаборТЗ);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
				КонецЕсли;
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			Если ЗначениеЗаполнено(ПроблемныйРегистратор) Тогда
				ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ПроблемныйРегистратор);
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось выполнить обработку данных регистра накопления ""Расчеты с клиентами по срокам"", при обновлении по причине: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(
					ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы,
					ТекстСообщения);
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

Функция ВидыОпераций()
	
	Массив = Новый Массив;
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаОрганизацияКонтрагент);
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуКонтрагентами);
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаКлиентаМеждуОрганизациями);
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуОрганизацияКонтрагент);
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуКонтрагентами);
	Массив.Добавить(Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносДолгаПоставщикуМеждуОрганизациями);
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли