﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ПриПолученииФормыДокумента(
		"ПеремаркировкаТоваровГИСМ",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Возврат;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПеремаркировкаТоваров() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = ПеремаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	ПеремаркировкаТоваровГИСМ.Ссылка ЕСТЬ НЕ NULL
	|	И (СтатусыИнформированияГИСМ.ДальнейшееДействие = ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные)
	|		ИЛИ СтатусыИнформированияГИСМ.ДальнейшееДействие = ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ)
	|		ИЛИ СтатусыИнформированияГИСМ.ДальнейшееДействие = ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров)
	|		ИЛИ СтатусыИнформированияГИСМ.ДальнейшееДействие = ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров))
	|	И СтатусыИнформированияГИСМ.Документ ССЫЛКА Документ.ПеремаркировкаТоваровГИСМ
	|	И (СтатусыИнформированияГИСМ.Документ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (СтатусыИнформированияГИСМ.Документ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПеремаркировкаТоваровОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = ПеремаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		 ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ),
	|		 ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров),
	|		 ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров),
	|		 ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен))
	|	И (ПеремаркировкаТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (ПеремаркировкаТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПеремаркировкаТоваровОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = ПеремаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации))
	|	И (ПеремаркировкаТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (ПеремаркировкаТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередаче;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ Тогда
		
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередачеСписаниеКиЗ;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров Тогда
		
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередачеМаркировкаТоваров;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров Тогда
		
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередачеПеремаркировкаТоваров;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.Передано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПереданоСписаниеКиЗ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМСписаниеКиЗ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПереданоМаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСММаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПереданоПеремаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМПеремаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМСписаниеКиЗ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМСписаниеКиЗ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваровПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСММаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСММаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваровПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМПеремаркировкаТоваров;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Возврат УведомлениеОСписанииКиЗXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ Тогда
		
		Возврат УведомлениеОСписанииКиЗXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров Тогда
		
		Возврат МаркировкаТоваровXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров Тогда
		
		Возврат ПеремаркировкаТоваровXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваровПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваровПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Формирует текст запроса ограничения доступа для RLS формата БСП 3.0
//
// Параметры:
//   Ограничение - (См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа).
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	ИнтеграцияГИСМПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение,
		ОбщегоНазначения.ИмяТаблицыПоСсылке(ПустаяСсылка()));

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Возврат МаркировкаТоваровГИСМУТ.АдаптированныйТекстЗапросаДвиженийПоРегиструПеремаркировкаТоваров(ИмяРегистра);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияГИСМ

Функция УведомлениеОСписанииКиЗXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремаркировкаТоваровГИСМ.Дата  КАК Дата,
	|	ПеремаркировкаТоваровГИСМ.Номер КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	ПеремаркировкаТоваровГИСМ.Организация КАК Организация,
	|	ПеремаркировкаТоваровГИСМ.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ПеремаркировкаТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	ПеремаркировкаТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки                   КАК НомерСтроки,
	|	Товары.СписываемаяСерия.НомерКиЗГИСМ КАК НомерКиЗ,
	|	Товары.СписываемаяСерия.RFIDTID      КАК TID,
	|	Товары.СписываемаяСерия.RFIDEPC      КАК EPC,
	|	Товары.ПричинаСписания               КАК ПричинаСписания
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|ИТОГИ ПО
	|	ПричинаСписания");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		Или Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОрганизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "reject_signs";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	УведомлениеОСписании = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	УведомлениеОСписании.action_id  = УведомлениеОСписании.action_id;
	
	Попытка
		УведомлениеОСписании.sender_gln = РеквизитыОрганизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОрганизации.GLN, Шапка);
	КонецПопытки;
	
	УведомлениеОСписании.reject_doc_num  = Шапка.Номер;
	УведомлениеОСписании.reject_doc_date = Шапка.Дата;
	
	ХранилищеВременныхДат = Новый Соответствие;
	ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
		УведомлениеОСписании,
		"reject_date",
		Шапка.Дата,
		ХранилищеВременныхДат);
	
	УведомлениеОСписании.rejects = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании, "rejects", Версия);
	
	Для Каждого СтрокаТЧИтогПоПричинеСписания Из Товары.Строки Цикл
		
		НоваяСтрокаПричинаСписания = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании.rejects, "by_reason", Версия);
		НоваяСтрокаПричинаСписания.reject_reason = ИнтеграцияГИСМ.ПричинаСписания(СтрокаТЧИтогПоПричинеСписания.ПричинаСписания);
		НоваяСтрокаПричинаСписания.signs = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрокаПричинаСписания, "signs", Версия);
		
		Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоПричинеСписания.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрокаПричинаСписания.signs, "sign", Версия);
			
			Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				
				НоваяСтрока.sign_num = СтрокаТЧ.НомерКиЗ;
				
			ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
				
				НоваяСтрока.sign_tid = СтрокаТЧ.TID;
				
			ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				
				Попытка
					НоваяСтрока.sign_sgtin = МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 указан некорректный EPC ""%2"".'"),
							ИнтеграцияИС.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика),
							СтрокаТЧ.EPC));
				КонецПопытки;
				
			КонецЕсли;
			
			НоваяСтрокаПричинаСписания.signs.sign.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		УведомлениеОСписании.rejects.by_reason.Добавить(НоваяСтрокаПричинаСписания);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = УведомлениеОСписании;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Версия       = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция МаркировкаТоваровXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремаркировкаТоваровГИСМ.Дата                     КАК Дата,
	|	ПеремаркировкаТоваровГИСМ.Номер                    КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	ПеремаркировкаТоваровГИСМ.Организация              КАК Организация,
	|	ПеремаркировкаТоваровГИСМ.Подразделение            КАК Подразделение
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ПеремаркировкаТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	ПеремаркировкаТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки           КАК НомерСтроки,
	|	Товары.Номенклатура          КАК Номенклатура,
	|	Товары.Характеристика        КАК Характеристика,
	|	
	|	Товары.GTIN               КАК GTIN,
	|	Товары.Серия.Номер        КАК СерийныйНомер,
	|	Товары.Серия.НомерКиЗГИСМ КАК НомерКиЗ,
	|	Товары.Серия.RFIDTID      КАК TID,
	|	Товары.Серия.RFIDEPC      КАК EPC,
	|	
	|	Товары.СписываемаяСерия.НомерКиЗГИСМ КАК НомерКиЗСтарый
	|	
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|ИТОГИ ПО
	|	GTIN");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		Или Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОрганизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	#Область Маркировка
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "unify_self_signs";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	МаркировкаТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	МаркировкаТоваров.action_id  = МаркировкаТоваров.action_id;
	
	Попытка
		МаркировкаТоваров.sender_gln = РеквизитыОрганизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Не заполнен GLN организации %1.'"), Шапка.Организация));
	КонецПопытки;
	
	ХранилищеВременныхДат = Новый Соответствие;
	ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
		МаркировкаТоваров,
		"unify_date",
		Шапка.Дата,
		ХранилищеВременныхДат);
	
	МаркировкаТоваров.unifies = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров, "unifies", Версия);
	
	Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
		
		НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров.unifies, "by_gtin", Версия);
		НоваяСтрока.sign_gtin = СтрокаТЧИтогПоGTIN.GTIN;
		
		Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл
			
			НоваяСтрокаUnion = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрока, "union", Версия);
			
			Попытка
				НоваяСтрокаUnion.gs1_sgtin = МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC);
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'Для номенклатуры %1 указан некорректный EPC ""%2"".'"),
						ИнтеграцияИС.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика),
						СтрокаТЧ.EPC));
			КонецПопытки;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.TID)
				И Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				НоваяСтрокаUnion.TID = СтрокаТЧ.TID;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				НоваяСтрокаUnion.sign_num = СтрокаТЧ.НомерКиЗ;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				НоваяСтрокаUnion.EPC = СтрокаТЧ.EPC;
			КонецЕсли;
			
			НоваяСтрока.union.Добавить(НоваяСтрокаUnion);
			
		КонецЦикла;
		
		МаркировкаТоваров.unifies.by_gtin.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = МаркировкаТоваров;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.Вставить("ТипСообщения", Перечисления.ТипыСообщенийГИСМ.Исходящее);
	СообщениеXML.Вставить("Операция",     Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров);
	СообщениеXML.Вставить("Организация",  Шапка.Организация);
	СообщениеXML.Вставить("Документ",     ДокументСсылка);
	СообщениеXML.Вставить("Версия",       НомерВерсии);
	
	СообщенияXML.Добавить(СообщениеXML);
	
	#КонецОбласти
	
	Возврат СообщенияXML;
	
КонецФункции

Функция ПеремаркировкаТоваровXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремаркировкаТоваровГИСМ.Дата                     КАК Дата,
	|	ПеремаркировкаТоваровГИСМ.Номер                    КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	ПеремаркировкаТоваровГИСМ.Организация              КАК Организация,
	|	ПеремаркировкаТоваровГИСМ.Подразделение            КАК Подразделение
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ КАК ПеремаркировкаТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ПеремаркировкаТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	ПеремаркировкаТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки           КАК НомерСтроки,
	|	Товары.Номенклатура          КАК Номенклатура,
	|	Товары.Характеристика        КАК Характеристика,
	|	
	|	Товары.GTIN               КАК GTIN,
	|	Товары.Серия.Номер        КАК СерийныйНомер,
	|	Товары.Серия.НомерКиЗГИСМ КАК НомерКиЗ,
	|	Товары.Серия.RFIDTID      КАК TID,
	|	Товары.Серия.RFIDEPC      КАК EPC,
	|	
	|	Товары.СписываемаяСерия.НомерКиЗГИСМ КАК НомерКиЗСтарый
	|	
	|ИЗ
	|	Документ.ПеремаркировкаТоваровГИСМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|ИТОГИ ПО
	|	GTIN");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		Или Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОрганизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	#Область Перемаркировка
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "sign_detail";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	Перемаркировка = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	Перемаркировка.action_id  = Перемаркировка.action_id;
	
	Попытка
		Перемаркировка.sender_gln = РеквизитыОрганизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОрганизации.GLN, Шапка);
	КонецПопытки;
	
	Перемаркировка.return = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Перемаркировка, "return", Версия);
	
	Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
		
		Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл

			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Перемаркировка.return, "signs", Версия);
			
			НоваяСтрока.sign_num     = СтрокаТЧ.НомерКиЗ;
			НоваяСтрока.old_sign_num = СтрокаТЧ.НомерКиЗСтарый;
			
			Перемаркировка.return.signs.Добавить(НоваяСтрока);
		
		КонецЦикла;
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = Перемаркировка;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.Вставить("ТипСообщения", Перечисления.ТипыСообщенийГИСМ.Исходящее);
	СообщениеXML.Вставить("Операция",     Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров);
	СообщениеXML.Вставить("Организация",  Шапка.Организация);
	СообщениеXML.Вставить("Документ",     ДокументСсылка);
	СообщениеXML.Вставить("Версия",       НомерВерсии);
	
	СообщенияXML.Добавить(СообщениеXML);
	
	#КонецОбласти
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура инициализации данных документа для механизма проведения.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ.
//  ДополнительныеСвойства - Структура - Дополнительные свойства для проведения.
//  Регистры - Строка, Структура, Неопределено - список регистров, разделенных запятой, или структура, в ключах которой
//                                                  - имена регистров Если неопределено - то всегда возвращается ИСТИНА.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	МаркировкаТоваровГИСМПереопределяемый.ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий
//
// Возвращаемое значение:
//   Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Документы.ПеремаркировкаТоваровГИСМ);
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//   Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//   (см. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий) - параметры указания серий
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ИнтеграцияИС.ПараметрыУказанияСерий(Метаданные.Документы.ПеремаркировкаТоваровГИСМ, Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//
// Параметры:
//   ПараметрыУказанияСерий - (см. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий) - параметры указания серий
//
// Возвращаемое значение:
//   Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Документы.ПеремаркировкаТоваровГИСМ, ПараметрыУказанияСерий);
	
КонецФункции

// Возвращает текст запроса для проверки заполнения серий
//
// Параметры:
//   ПараметрыУказанияСерий - (см. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий) - параметры указания серий
//
// Возвращаемое значение:
//   Строка - текст запроса.
//
Функция ТекстЗапросаПроверкиЗаполненияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаПроверкиЗаполненияСерий(Метаданные.Документы.ПеремаркировкаТоваровГИСМ, ПараметрыУказанияСерий);

КонецФункции

#КонецОбласти 

#КонецОбласти

#КонецЕсли
